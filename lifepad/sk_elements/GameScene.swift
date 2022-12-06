//
// GameScene.swift
// Defines and handles all background threading and state changes for the simulation
// Relies on two threads: UI & Simulation to handle changes given by the user or the simulation.
// All drawn grid information stored in grid (a Grid object populated with SpriteCell structs that can be drawn)
//

// Sources
//
// Main guidepoint: https://thecoderpilot.blog/2020/10/21/building-an-ios-version-of-the-conways-game-of-life/


import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene {
    @ObservedObject var customizationManager: CustomizationManager // Holds UI and customization info
    
    let SIM_ACTION_KEY = "simulation" // Key for the simulation thread
    let UI_ACTION_KEY = "ui" // key for the UI thread
    let minSpeed = 0.25 // lowest possible animation speed for slider
    let maxSpeed = 2.0 // highest possible animation speed for slider
    
    let rows = Int(round(UIScreen.main.bounds.height / 7.5))
    let cols = Int(round(UIScreen.main.bounds.width / 7.5))
    let blockSize: CGFloat = 10.0 // size of distances between rows and cols and cells
    let neighborCoords: [(Int, Int)] = makeNeighborCoords() // array of coordinates to check around every cell
    
    var grid: Grid! // area where cells / lines are drawn
    var simCoroutine: SKAction! // holds simulation thread info
    var initGrid: [[Cell]]!
    
    var lastCellColor: Color!
    var lastGridColor: Color!
    var lastSpeedPercentage: Double!
    
    init(customizationManager: CustomizationManager) {
        
        // set sim and customization manager
        self.customizationManager = customizationManager
        
        let initGrid = randomGrid(rows: rows, cols: cols) // randomize the grid on load
        self.initGrid = initGrid
        
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
        
        // simulation coroutine settings
        let delay = SKAction.wait(forDuration: 0.08)
        let coroutine = SKAction.perform(#selector(runSimulation), onTarget: self) // coroutine for cells
        let stepSequence = SKAction.sequence([delay, coroutine])
        let simulation = SKAction.repeatForever(stepSequence)
        
        self.simCoroutine = simulation
        
    }
    
    // required by swiftc
    required init?(coder aDecoder: NSCoder) {
        self.customizationManager = CustomizationManager()
        super.init(coder: aDecoder)
    }
    
    // allows for editing (turning cells on and off
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
        
        customizationManager.stepStack.push(element: initGrid) // place the initial grid in the history
        
        // ui settings
        let uiDelay = SKAction.wait(forDuration: 0.08)
        let uiCoroutine = SKAction.perform(#selector(checkForUIChanges), onTarget: self)
        let uiStepSequence = SKAction.sequence([uiDelay, uiCoroutine])
        let uiThread = SKAction.repeatForever(uiStepSequence)
        
        self.run(self.simCoroutine, withKey: SIM_ACTION_KEY)
        self.run(uiThread, withKey: UI_ACTION_KEY)
    }
    
    // bounds the possible animation speeds given by the slider
    func calculateSpeed(percentage: Double) -> Double {
        // at 0 the speed should be about a quarter
        // at 1 the speed should be 2
        return (percentage * (maxSpeed - minSpeed)) + minSpeed
    }
    
    // Main UI thread
    @objc func checkForUIChanges() {
        // check for UI changes from the "Controller"
        // Controller "emits" changes that must be communicated to the SKScene
        
        // clear the board when a change is received
        if(customizationManager.controller.clearChange) {
            grid.wipeGrid()
            customizationManager.controller.clearChange = false
        }
        
        // load a preset
        if(customizationManager.controller.loadPreset != nil) {
            grid.loadPreset(preset: customizationManager.controller.loadPreset!)
            customizationManager.stepStack.stack = [spriteGridToGrid()] // reset the stack with just this frame
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
        
        // hide ui if requested
        if(customizationManager.controller.hideUIChange) {
            customizationManager.uiOpacity = 0.0
            customizationManager.controller.hideUIChange = false
        }
        
        // if the speed percentage has changed, alter the SKAction
        if customizationManager.speedPercentage != self.lastSpeedPercentage {
            // somewhat of a UI change, change the delay value of the simulation thread
            self.action(forKey: SIM_ACTION_KEY)!.speed = calculateSpeed(percentage: customizationManager.speedPercentage)
        }
        
        // set the last color that was specified
        self.lastCellColor = customizationManager.cellColor
        self.lastGridColor = customizationManager.gridColor
        self.lastSpeedPercentage = customizationManager.speedPercentage
        
    }
    
    // copy the last sprite grid to place in the history
    func spriteGridToGrid() -> [[Cell]] {
        
        var newGrid: [[Cell]] = []
        
        for i in 0..<rows {
            var tempRow: [Cell] = []
            for j in 0..<cols {
                tempRow.append(Cell(state: grid.spriteGrid[i][j].alive, row: i, col: j))
            }
            newGrid.append(tempRow)
        }
        
        return newGrid
        
    }
    
    // Add the current simulation frame to the stack, generate the next one, and draw it
    // Similar to the "playing" if block in the main thread
    func sceneNextGen() -> [[Cell]] {
        
        let prevGrid = spriteGridToGrid() // returns a copy of the last sprite grid for the stack
        customizationManager.stepStack.push(element: prevGrid)
        
        let changedGrid = nextGen(cellGrid: grid.spriteGrid, rows: rows, cols: cols, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
        
        return changedGrid
    }
    
    // Alter the CellSprite structs' appearance on the GameScene
    // Drawing the simulation state
    func drawGen(refGrid: [[Cell]]?) {
        if refGrid != nil {
            for i in 0..<rows {
                for j in 0..<cols {
                    grid.spriteGrid[i][j].alive = refGrid![i][j].state
                }
            }
        } else {
            return
        }
    }
    
    // Main simulation thread, also listens for navigation across the simulation frame history via the "StepStack"
    @objc func runSimulation() {
        
        // draw the last "play"
        if(customizationManager.controller.loadLastFrame) {
            let bottom = customizationManager.stepStack.bottom()
            if bottom != nil {
                drawGen(refGrid: bottom)
                customizationManager.stepStack.stack = [bottom!]
            }
            customizationManager.controller.loadLastFrame = false
        }
            
        // go back one frame on the stack
        if(customizationManager.controller.previous) {
            let prevGrid = customizationManager.stepStack.pop()
            drawGen(refGrid: prevGrid)
            customizationManager.controller.previous = false
        }
        
        // go forward one frame on the stack
        if(customizationManager.controller.next) {
            let changedGrid = sceneNextGen()
            drawGen(refGrid: changedGrid)
            customizationManager.controller.next = false
        }
        
        // while playing...
        if(customizationManager.playing) {
            // calculate next gen
            let changedGrid = sceneNextGen()
            
            // draw the next gen
            drawGen(refGrid: changedGrid)
        }
    }
}
