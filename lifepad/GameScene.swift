import SpriteKit
import GameplayKit
import SwiftUI

func randomizeGrid(sim: Simulation) {
    for i in 0..<sim.rows {
        for j in 0..<sim.cols {
            if(Int.random(in: 1..<9) == 1) {
                sim.grid[i][j].state = true
                sim.liveCells.append(sim.grid[i][j])
            }
        }
    }
}

class GameScene: SKScene {
    let rows = Int(round(UIScreen.main.bounds.height / 7.5))
    let cols = Int(round(UIScreen.main.bounds.width / 7.5))
    let blockSize: CGFloat = 10.0
    var grid: Grid! // area where cells / lines are drawn
    var sim: Simulation! // holds the computational portion of the simulation
    let neighborCoords: [(Int, Int)] = makeNeighborCoords() // array of coordinates to check around every cell
    var previousCameraPoint = CGPoint.zero
    
    var lastCellColor: Color!
    var lastGridColor: Color!
    
    @ObservedObject var customizationManager: CustomizationManager //
    
    init(customizationManager: CustomizationManager) {
        
        // set sim and customization manager
        self.sim = initRandomSim(rows: rows, cols: cols)
        self.customizationManager = customizationManager
        
        // initialize spritekit grid, draw all cells
        grid = Grid(blockSize: blockSize, rows: rows, cols: cols, initCellColor: UIColor(customizationManager.cellColor), initGridColor: UIColor(customizationManager.gridColor))
        grid.populateGrid(sim: sim, rows: rows, cols: cols)
        
        // set initial colors for color updating in sim
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        
        super.init(size: CGSize(width: cols * 12, height: rows * 12))
        
        let cam = SKCameraNode()
        
        self.camera = cam
        self.backgroundColor = UIColor(lastGridColor) // init grid / background color
        
        print("GAME SCENE INIT")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.customizationManager = CustomizationManager()
        super.init(coder: aDecoder)
    }
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // ignore
        }
    }
    
    // acts like an init / startup method
    override func didMove(to: SKView) {
        
        print("GAME SCENE DIDMOVE")

        // centers / aligns the grid
        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // adds the grid to the scene
        addChild(grid)
        
        // grid settings
        let delay = SKAction.wait(forDuration: 0.08)
        let coroutine = SKAction.perform(#selector(runSimulation), onTarget: self) // coroutine for cells
        let stepSequence = SKAction.sequence([delay, coroutine])
        let simulation = SKAction.repeatForever(stepSequence)
        
        // init camera
        self.camera?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // camera settings
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        to.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(handlePinch(_:)))
        to.addGestureRecognizer(pinchGesture)
        
        // tap to toggle a cell
//        let tapGesture = UITapGestureRecognizer()
//        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
//        to.addGestureRecognizer(tapGesture)
        
        self.run(simulation)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let position = touch.location(in:self)
//            print(position)
//            let node = atPoint(position)
//            print(node)
//            if node != self {
////                let action = SKAction.rotate(by:CGFloat.pi*2, duration: 1)
////                node.run(action)
//            }
//            else {
//                let x = size.width / 2 + position.x
//                let y = size.height / 2 - position.y
//                let row = Int(floor(x / blockSize))
//                let col = Int(floor(y / blockSize))
//                print("\(row) \(col)")
//            }
//        }
//    }

    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        let position = sender.location(in: view)
//        let node = atPoint(position)
//        if node == self {
//            //
//            print("self")
//        } else {
//            let x = size.width / 2 + position.x
//            let y = size.height / 2 - position.y
//            let row = Int(floor(x / blockSize))
//            let col = Int(floor(y / blockSize))
//            print("\(row) \(col)")
//        }
//    }
    
    // camera pan gesture
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        // camera has a weak reference, check before proceeding
        guard let camera = self.camera else {
            print("panning")
            return
        }
        
        // save camera position when starting movement
        if sender.state == .began {
            previousCameraPoint = camera.position
        }

        // move the camera
        let translation = sender.translation(in: self.view)
        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1
            , y: previousCameraPoint.y + translation.y
        )

        camera.position = newPosition
    }

    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            print("pinching")
            return
        }
        
        if sender.state == .began || sender.state == .changed {
            let currentScale: CGFloat = (camera.xScale)
            let minScale: CGFloat = 0.5
            let maxScale: CGFloat = 2.0
            let zoomSpeed: CGFloat = 0.5
            var deltaScale = sender.scale

            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            deltaScale = min(deltaScale, maxScale / currentScale)
            deltaScale = max(deltaScale, minScale / currentScale)

            camera.xScale = deltaScale
            camera.yScale = deltaScale
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    @objc func runSimulation() {
        
        // check for UI changes from the "Controller"
        
        // clear the board when a change is received
        if(customizationManager.controller.clearChange) {
            grid.wipeGrid()
            sim.grid = emptyGrid(rows: sim.rows, cols: sim.cols)
            sim.liveCells = []
            customizationManager.controller.clearChange = false
        }
        
        // set cell colors if changed
        if(self.lastCellColor != customizationManager.cellColor) {
            for i in 0..<sim.rows {
                for j in 0..<sim.cols {
                    grid.spriteGrid[i][j].fillColor = UIColor(customizationManager.cellColor)
                }
            }
        }
        
        // set grid colors if changed
        if(self.lastGridColor != customizationManager.gridColor) {
//            grid.color = UIColor(customizationManager.gridColor)
            self.backgroundColor = UIColor(customizationManager.gridColor)
            self.grid.setTexture(color: findLineColor(color: UIColor(customizationManager.gridColor)))
//            self.grid.texture = gridTexture(blockSize: self.blockSize, rows: self.rows, cols: self.cols, color: findLineColor(color: UIColor(customizationManager.gridColor)))
        }
        
        if(customizationManager.playing && !sim.liveCells.isEmpty) {
            // calculate next gen
            sim = nextGen(sim: sim, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
            
            // draw the next gen
            for i in 0..<sim.rows {
                for j in 0..<sim.cols {
                    grid.spriteGrid[i][j].alive = sim.grid[i][j].state
                    grid.spriteGrid[i][j].fillColor = UIColor(customizationManager.cellColor) // TODO should be moved to a function that simply updates all CellSprite children on the grid
                }
            }
        }
        
        // set the last color that was specified
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        
    }
}
