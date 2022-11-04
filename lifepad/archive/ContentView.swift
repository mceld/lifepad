//
// ContentView.swift
// Main view holding all Lifepad

//
// MARK: ARCHIVE
// Archive of SwiftUI attempt, non-functional
//


import SwiftUI

struct ContentView: View {
    
    // These values should be fixed, rotation of screen should just change the orientation of the controls
    // as well as the referencing of the grid (col -> row, row -> col)
    let length: Int
    let width: Int
    
    @State var doWrap: Bool = false
    @State var sim: Simulation
    
    init() {
        
        let length = Int(round(UIScreen.main.bounds.height / 3))
        let width = Int(round(UIScreen.main.bounds.width / 3))
        let sim = Simulation(length: length, width: width, grid: emptyGrid(length: length, width: width), liveCells: [])
        
        // init neighbor cells
        // covers all of the neighbor spots
//        for i in -1...1 {
//            for j in -1...1 {
//                neighborCoords.append((vertical: i, horizontal: j))
//            }
//        }
        
        // Load a preset of some kind
        // randomly populate cells
        for i in 0..<length {
            for j in 0..<width {
                if(Int.random(in: 1..<9) == 1) {
                    sim.grid[i][j].state = true
                    sim.liveCells.append(sim.grid[i][j])
                }
            }
        }
        
        self.length = length
        self.width = width
        self.sim = sim
        
//        while(sim.liveCells.count != 0) {
//            sim = nextGen(sim: sim, doWrap: doWrap, neighborCoords: neighborCoords)
//        }
        
        // launch life in some background thread with 'running' state that pauses / plays the updating
    }
    
    var body: some View {
        // main area
        EditorGrid(length: length, width: width, sim: $sim, doWrap: $doWrap)
        
        // Controls - should float above the scrollable area
//        Controls()
            // Button 1...n for each control on prototype
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
