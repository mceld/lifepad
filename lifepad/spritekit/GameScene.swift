//
//  GameScene.swift
//  lifepad_game
//
//  Created by GCCISAdmin on 11/3/22.
//

import SpriteKit
import GameplayKit

func randomizeGrid(sim: Simulation) {
    for i in 0..<length {
        for j in 0..<width {
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
    let sim = Simulation(length: length, width: width, grid: emptyGrid(length: length, width: width), liveCells: [])
    // acts like an init method
    
    override func didMove(to: SKView) {
        
        let simCoroutine = SimulationCoroutine(sim: sim)
        
        if let grid = Grid(blockSize: 8.0, rows:50, cols:50, sim: simCoroutine) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
        }
        
        simCoroutine.start()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
