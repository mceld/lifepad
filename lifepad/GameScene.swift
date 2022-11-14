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
    var grid: Grid! // area where cells / lines are drawn
    var sim: Simulation! // holds the computational portion of the simulation
    let neighborCoords: [(Int, Int)] = makeNeighborCoords() // array of coordinates to check around every cell
    @ObservedObject var customizationManager: CustomizationManager //
    
    init(customizationManager: CustomizationManager) {
        sim = Simulation(
            rows: rows
            , cols: cols
            , grid: emptyGrid(
                rows: rows
                , cols: cols
            )
            , liveCells: []
        )
        randomizeGrid(sim: sim)
        
        self.customizationManager = customizationManager
        
        grid = Grid(blockSize: 10.0, rows: rows, cols: cols, initCellColor: customizationManager.cellColor)
        grid.populateGrid(sim: sim, rows: rows, cols: cols)

        super.init(size: CGSize(width: cols * 12, height: rows * 12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.customizationManager = CustomizationManager()
        super.init(coder: aDecoder)
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
        
        self.run(simulation)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    @objc func runSimulation() {
        // calculate next gen
        sim = nextGen(sim: sim, doWrap: customizationManager.doWrap, neighborCoords: neighborCoords)
        
        if(customizationManager.playing) {
            // draw the next gen
            for i in 0..<sim.rows {
                for j in 0..<sim.cols {
                    grid.spriteGrid[i][j].alive = sim.grid[i][j].state
                    grid.spriteGrid[i][j].fillColor = customizationManager.cellColor // TODO should be moved to a function that simply updates all CellSprite children on the grid
                }
            }
        }
        
    }
}
