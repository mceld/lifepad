//
//  SimulationCoroutine.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/4/22.
//

import Foundation
import SwiftUI

class SimulationCoroutine: Thread, ObservableObject {
    // Controls
    var playing: Bool = true
    
    // Sim values
    let neighboorCoords: [(Int, Int)] = makeNeighborCoords()
    var doWrap: Bool = false
    @Published var sim: Simulation
    
    func main(neighborCoords: [(Int, Int)]) async {
        while(sim.liveCells.count != 0 && self.playing) {
            self.sim = nextGen(sim: self.sim, doWrap: self.doWrap, neighborCoords: neighborCoords)
        }
    }
    
    init(sim: Simulation) {
        
        // Load a preset of some kind
        // randomly populate cells
        self.sim = sim
        
    }
}
