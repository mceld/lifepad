import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene {
    @ObservedObject var customizationManager: CustomizationManager // Holds UI and customization info
    
    let rows = Int(round(UIScreen.main.bounds.height / 7.5))
    let cols = Int(round(UIScreen.main.bounds.width / 7.5))
    let blockSize: CGFloat = 10.0
    let neighborCoords: [(Int, Int)] = makeNeighborCoords() // array of coordinates to check around every cell
    
    var grid: Grid! // area where cells / lines are drawn
    
    var previousCameraPoint = CGPoint.zero
    var lastCellColor: Color!
    var lastGridColor: Color!
    
    init(customizationManager: CustomizationManager) {
        
        // set sim and customization manager
        self.customizationManager = customizationManager
        
        let initGrid = randomGrid(rows: rows, cols: cols)
        
        // initialize spritekit grid, draw all cells
        grid = Grid(blockSize: blockSize, rows: rows, cols: cols, initCellColor: UIColor(customizationManager.cellColor), initGridColor: UIColor(customizationManager.gridColor))
        grid.populateGrid(grid: initGrid, rows: rows, cols: cols)
        
        // set initial colors for color updating in sim
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        
        // size should be equal to cols/rows * blocksize
        super.init(size: CGSize(width: cols * Int(blockSize), height: rows * Int(blockSize)))
        
        // set up the camera to handle pinch / drag gestures
        // MARK: Can be used as a handle to recenter as well.
        let cam = SKCameraNode()
        self.camera = cam
        
        self.backgroundColor = UIColor(lastGridColor) // init grid / background color
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
//        let panGesture = UIPanGestureRecognizer()
//        panGesture.addTarget(self, action: #selector(handlePan(_:)))
//        to.addGestureRecognizer(panGesture)
//
//        let pinchGesture = UIPinchGestureRecognizer()
//        pinchGesture.addTarget(self, action: #selector(handlePinch(_:)))
//        to.addGestureRecognizer(pinchGesture)
        
        // tap to toggle a cell
//        let tapGesture = UITapGestureRecognizer()
//        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
//        to.addGestureRecognizer(tapGesture)
        
        self.run(simulation)
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        if(customizationManager.uiOpacity < 1.0) {
//            print("setting opacity")
//            self.customizationManager.uiOpacity = 1.0
//        }
//    }
    
    // camera pan gesture
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        // camera has a weak reference, check before proceeding
        guard let camera = self.camera else {
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
            customizationManager.controller.clearChange = false
        }
        
        // set cell colors if changed
        if(self.lastCellColor != customizationManager.cellColor) {
            for i in 0..<rows {
                for j in 0..<cols {
                    grid.spriteGrid[i][j].fillColor = UIColor(customizationManager.cellColor)
                }
            }
        }
        
        // set grid colors if changed
        if(self.lastGridColor != customizationManager.gridColor) {
            self.backgroundColor = UIColor(customizationManager.gridColor)
            self.grid.setTexture(color: findLineColor(color: UIColor(customizationManager.gridColor)))
        }
        
        if(customizationManager.controller.hideUIChange) {
            customizationManager.uiOpacity = 0.0
//            for i in 0..<rows {
//                for j in 0..<cols {
//                    grid.spriteGrid[i][j].strokeColor = .clear
//                }
//            }
//            grid.texture = gridTexture(blockSize: blockSize, rows: rows, cols: cols, color: UIColor.clear)
            customizationManager.controller.hideUIChange = false
        }
        
        // // // // simulation running, changes from ui controller computed // // // //
        
        if(customizationManager.playing) {
            // calculate next gen
//            sim = nextGen(sim: sim, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
            let changedGrid = nextGen(cellGrid: grid.spriteGrid, rows: rows, cols: cols, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
            
            // draw the next gen
            for i in 0..<rows {
                for j in 0..<cols {
                    grid.spriteGrid[i][j].alive = changedGrid[i][j].state
//                    grid.spriteGrid[i][j].fillColor = UIColor(customizationManager.cellColor) // TODO should be moved to a function that simply updates all CellSprite children on the grid
                }
            }
            
            // add storage in stack here
        }
        
        // set the last color that was specified
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        
    }
}
