//
// ContentView.swift
// Main view holding all Lifepad controls and scenes

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    // These values should be fixed, rotation of screen should just change the orientation of the controls
    // as well as the referencing of the grid (col -> row, row -> col)
    var scene: SKScene?
    
    init() {
        if let game = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
//            game.scaleMode = .aspectFill
            print("hello")
            self.scene = game
        } else {
            self.scene = nil
        }
    }
    
    var body: some View {
        // main area
//        EditorGrid(length: length, width: width, sim: $sim, doWrap: $doWrap)
        
        // Controls - should float above the scrollable area
//        Controls()
            // Button 1...n for each control on prototype
        ZStack {
            SpriteView(scene: scene!)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentViewArchive_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
