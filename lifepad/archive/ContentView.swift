//
// ContentView.swift
// Main view holding all Lifepad controls and scenes

import SwiftUI
import SpriteKit

struct ContentViewArchive: View {
    
    // These values should be fixed, rotation of screen should just change the orientation of the controls
    // as well as the referencing of the grid (col -> row, row -> col)
    var scene: SKScene {
        let scene = GameScene(coder: NSCoder())
        return scene!
    }
    
    
    var body: some View {
        SpriteView(scene: scene)
        
        // main area
//        EditorGrid(length: length, width: width, sim: $sim, doWrap: $doWrap)
        
        // Controls - should float above the scrollable area
//        Controls()
            // Button 1...n for each control on prototype
        Text("text")
    }
}

struct ContentViewArchive_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewArchive()
    }
}
