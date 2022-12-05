import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene {
    @ObservedObject var customizationManager: CustomizationManager // Holds UI and customization info
    
    let SIM_ACTION_KEY = "simulation"
    let UI_ACTION_KEY = "ui"
    
    let rows = Int(round(UIScreen.main.bounds.height / 7.5))
    let cols = Int(round(UIScreen.main.bounds.width / 7.5))
    let blockSize: CGFloat = 10.0
    let neighborCoords: [(Int, Int)] = makeNeighborCoords() // array of coordinates to check around every cell
    
    var grid: Grid! // area where cells / lines are drawn
    
    var simCoroutine: SKAction!
    
    var previousCameraPoint = CGPoint.zero
    var lastCellColor: Color!
    var lastGridColor: Color!
    var lastSpeedPercentage: Double!
    
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
        
        // set initial speed
        self.lastSpeedPercentage = customizationManager.speedPercentage
        
        // size should be equal to cols/rows * blocksize
        super.init(size: CGSize(width: cols * Int(blockSize), height: rows * Int(blockSize)))
        
        self.backgroundColor = UIColor(lastGridColor) // init grid / background color
        
        // grid settings
        let delay = SKAction.wait(forDuration: 0.08)
        let coroutine = SKAction.perform(#selector(runSimulation), onTarget: self) // coroutine for cells
        let stepSequence = SKAction.sequence([delay, coroutine])
        let simulation = SKAction.repeatForever(stepSequence)
        
        self.simCoroutine = simulation
        
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
        
        // ui settings
        let uiDelay = SKAction.wait(forDuration: 0.08)
        let uiCoroutine = SKAction.perform(#selector(checkForChanges), onTarget: self)
        let uiStepSequence = SKAction.sequence([uiDelay, uiCoroutine])
        let uiThread = SKAction.repeatForever(uiStepSequence)
        
        self.run(self.simCoroutine, withKey: SIM_ACTION_KEY)
        self.run(uiThread, withKey: UI_ACTION_KEY)
    }
    
    // MARK: could be used to handle editing
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        if(customizationManager.uiOpacity < 1.0) {
//            print("setting opacity")
//            self.customizationManager.uiOpacity = 1.0
//        }
//    }
    
    // MARK: could be used to control speed or other appearance fields
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func calculateSpeed(percentage: Double) -> Double {
        let minSpeed = 0.25
        let maxSpeed = 2.0
        // at 0 the speed should be about a quarter
        // at 1 the speed should be 2
        return (percentage * (maxSpeed - minSpeed)) + minSpeed
    }
    
    @objc func checkForChanges() {
        // check for UI changes from the "Controller"
        
        // clear the board when a change is received
        if(customizationManager.controller.clearChange) {
            grid.wipeGrid()
            customizationManager.controller.clearChange = false
        }
        
        // load a preset
        if(customizationManager.controller.loadPreset != nil) {
            grid.loadPreset(preset: customizationManager.controller.loadPreset!)
            customizationManager.controller.loadPreset = nil
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
        
        if customizationManager.speedPercentage != self.lastSpeedPercentage {
            // somewhat of a UI change, change the delay value of the simulation thread
            self.action(forKey: SIM_ACTION_KEY)!.speed = calculateSpeed(percentage: customizationManager.speedPercentage)
        }
        
        // set the last color that was specified
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        self.lastSpeedPercentage = customizationManager.speedPercentage
        
        
    }
    
    @objc func runSimulation() {
        // // // // simulation running, changes from ui controller computed // // // //
        
        if(customizationManager.playing) {
            // calculate next gen
//            sim = nextGen(sim: sim, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
            let changedGrid = nextGen(cellGrid: grid.spriteGrid, rows: rows, cols: cols, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
            
            // draw the next gen
            for i in 0..<rows {
                for j in 0..<cols {
                    grid.spriteGrid[i][j].alive = changedGrid[i][j].state
                }
            }
            // add storage in stack here
        }
    }
}
