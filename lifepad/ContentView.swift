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
    
    @EnvironmentObject var customizationManager: CustomizationManager
//    @State var cellColor: UIColor = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)
    
    var scene: SKScene {
        let game = GameScene(cellColor: $customizationManager.cellColor)
        game.scaleMode = .aspectFill
        return game
    }
    
//    init() {
////        if let game = SKScene(fileNamed: "GameScene") {
////            // Set the scale mode to scale to fit the window
////            game.scaleMode = .aspectFill
//////            let sim = Simulation(
//////                rows: rows
//////                , cols: cols
//////                , grid: emptyGrid(
//////                    rows: rows
//////                    , cols: cols
//////                )
//////                , liveCells: []
//////            )
//////            randomizeGrid(sim: sim)
//////
//////            let grid = Grid(blockSize: 10.0, rows: rows, cols: cols)!
//////            grid.populateGrid(sim: sim, rows: rows, cols: cols)
////
////            self.scene = game
////        } else {
////            self.scene = nil
////            return
////        }
//    }
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack { // Control Group
                
                VStack {
                    CircleButton(iconName: "paintpalette", onClick: {self.customizationManager.cellColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)})
                    CircleButton(iconName: "infinity", onClick: {}) // wrap
                    CircleButton(iconName: "trash", onClick: {}) // clear grid
                }
                CircleButton(iconName: "arrow.counterclockwise", onClick: {}) // restart from last play
                ControlBlock() // play / pause controls
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
