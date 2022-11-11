//
// ContentView.swift
// Main view holding all Lifepad controls and scenes


// styling ???
// environment variables
// what can be customized?
// wrapping
// bgcolor
// fgcolor
//

// listeners/routes from environment variables to UIdrawing routines


//https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview
//https://stackoverflow.com/questions/68365480/pass-share-class-with-spriteview-gamescene-from-a-swiftui-view // State and environment

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    // These values should be fixed, rotation of screen should just change the orientation of the controls
    // as well as the referencing of the grid (col -> row, row -> col)
    var scene: SKScene?
    // maybe use environment object to broadcast changes about the state
    @EnvironmentObject var customizationManager: CustomizationManager
    @State var cellColor: UIColor = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)
    
    init() {
        if let game = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            game.scaleMode = .aspectFill
            self.scene = game
        } else {
            self.scene = nil
            return
        }
    }
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene!)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack { // Control Group
                VStack {
                    CircleButton(iconName: "paintpalette") // customize
                    CircleButton(iconName: "infinity") // wrap
                    CircleButton(iconName: "trash") // clear grid
                }
                CircleButton(iconName: "arrow.counterclockwise") // restart from last play
                ControlBlock() // play / pause controls
                CircleButton(iconName: "speedometer") // speed controls
                VStack {
                    CircleButton(iconName: "eye.slash") // hide ui
                    CircleButton(iconName: "text.book.closed") // library of configs
                }
            }
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .bottom
                )
        }
    }
}

struct ContentViewArchive_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
