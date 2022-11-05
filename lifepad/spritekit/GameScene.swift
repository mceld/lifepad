//
//  GameScene.swift
//  lifepad_game
//
//  Created by GCCISAdmin on 11/3/22.
//

import SpriteKit
import GameplayKit

func randomizeGrid(sim: Simulation) {
    for i in 0..<sim.length {
        for j in 0..<sim.width {
            if(Int.random(in: 1..<9) == 1) {
                sim.grid[i][j].state = true
                sim.liveCells.append(sim.grid[i][j])
            }
        }
    }
}

class GameScene: SKScene {
//        let length = Int(round(UIScreen.main.bounds.height / 3))
//        let width = Int(round(UIScreen.main.bounds.width / 3))
    let length = 50
    let width = 50
    
    // Store the Simulation object here and create a "run" function that will
    // run asynchronously and add all creatures to the grid
    // see objc run function at bottom
 
    // acts like an init / startup method
    override func didMove(to: SKView) {
        let sim = Simulation(length: length, width: width, grid: emptyGrid(length: length, width: width), liveCells: [])
        randomizeGrid(sim: sim)
//        let simCoroutine = SimulationCoroutine(sim: sim)
        
        if let grid = Grid(blockSize: 8.0, rows:50, cols:50) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
        }
        
        
        
//        simCoroutine.start()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    @objc func run() {
        // maybe ...
        /**
         Send a Simulation object to Grid, replacing its current list of live cells (blank at first)
         with the list of live cells, and drawing each of them
         Step the simulation at the end or beginning, the coroutine handler (SKScene utility, see github example)
         will handle the repeated calling of this method
         Call this method as long as there are live cells, otherwise, pause somehow
         */
    }
}
