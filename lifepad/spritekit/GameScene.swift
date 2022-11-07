//
//  GameScene.swift
//  lifepad_game
//
//  Created by GCCISAdmin on 11/3/22.
//

import SpriteKit
import GameplayKit

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
    let rows = Int(round(UIScreen.main.bounds.height / 6))
    let cols = Int(round(UIScreen.main.bounds.width / 6))
//    let rows = 50
//    let cols = 50
    var grid: Grid
    var sim: Simulation
    let neighborCoords: [(Int, Int)] = makeNeighborCoords()
    
    required init?(coder aDecoder: NSCoder) {
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
        
        grid = Grid(blockSize: 10.0, rows: rows, cols: cols)!
        grid.populateGrid(sim: sim, rows: rows, cols: cols)
        
        super.init(coder: aDecoder)
    }
    
    // acts like an init / startup method
    override func didMove(to: SKView) {

        grid.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(grid)
        
        let delay = SKAction.wait(forDuration: 0.1)
        let coroutine = SKAction.perform(#selector(runSimulation), onTarget: self)
        let stepSequence = SKAction.sequence([delay, coroutine])
        let simulation = SKAction.repeatForever(stepSequence)
        
        self.run(simulation)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    @objc func runSimulation() {
        // maybe ...
        /**
         Send a Simulation object to Grid, replacing its current list of live cells (blank at first)
         with the list of live cells, and drawing each of them
         Step the simulation at the end or beginning, the coroutine handler (SKScene utility, see github example)
         will handle the repeated calling of this method
         Call this method as long as there are live cells, otherwise, pause somehow
         */
        
        // wipe the pixels
        for i in 0..<sim.rows {
            for j in 0..<sim.cols {
                grid.spriteGrid[i][j].alive = false
            }
        }
        
        // calculate next gen
        sim = nextGen(sim: sim, doWrap: true, neighborCoords: neighborCoords)
        
        // draw the next gen
        for i in 0..<sim.rows {
            for j in 0..<sim.cols {
                grid.spriteGrid[i][j].alive = sim.grid[i][j].state
            }
        }
        
    }
}
