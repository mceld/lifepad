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
    @StateObject var customizationManager = CustomizationManager()
    
    var scene: SKScene {
        let game = GameScene(customizationManager: customizationManager)
        game.scaleMode = .aspectFill
        return game
    }
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack { // Control Group
                
                VStack {
                    CircleButton(iconName: "paintpalette", onClick: {print(customizationManager);self.customizationManager.cellColor = UIColor(red: Double.random(in: 1...1.0), green: Double.random(in: 1...1.0), blue: Double.random(in: 1...1.0), alpha: 1.0)})
                    CircleButton(iconName: "infinity", onClick: {self.customizationManager.doWrap.toggle()}) // wrap
                    CircleButton(iconName: "trash", onClick: {}) // clear grid
                }
                CircleButton(iconName: "arrow.counterclockwise", onClick: {}) // restart from last play
                ControlBlock(playPauseAction: {self.customizationManager.playing.toggle()}) // play / pause controls
                CircleButton(iconName: "speedometer", onClick: {}) // speed controls
                VStack {
                    CircleButton(iconName: "eye.slash", onClick: {}) // hide ui
                    CircleButton(iconName: "text.book.closed", onClick: {}) // library of configs
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
