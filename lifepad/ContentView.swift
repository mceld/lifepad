// Main view holding all Lifepad controls and scenes
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview
// https://stackoverflow.com/questions/68365480/pass-share-class-with-spriteview-gamescene-from-a-swiftui-view // State and environment
// https://stackoverflow.com/questions/38865788/moving-camera-in-spritekit-swift

// TODO
// Editing the grid, how to manage race condition?
// Wiping the grid
// Speed controls
// Color controls, pane with color picker


import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var customizationManager = CustomizationManager()
    @State var wrapButtonState: Bool = false
    
    var scene: GameScene {
        let game = GameScene(customizationManager: customizationManager)
        game.scaleMode = .aspectFill
        return game
    }
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack { // Control Group
                
                // customization, wrap, clear grid
                VStack {
//                    CircleButton( // customize color
//                        iconName: "paintpalette"
//                        , onClick: {
//                            print(customizationManager)
//                            self.customizationManager.cellColor =
//                            UIColor(
//                                red: Double.random(in: 0...1.0)
//                                , green: Double.random(in: 0...1.0)
//                                , blue: Double.random(in: 0...1.0)
//                                , alpha: 1.0
//                            )
//                        }
//                        // TODO change this to redraw the grid with the color changes only
//                    )
                    ColorPicker("", selection: $customizationManager.cellColor)
                    
                    CircleButton( // wrap grid
                        iconName: wrapButtonState ? "infinity" : "lock"
                        , onClick: {
                            self.customizationManager.doWrap.toggle()
                            wrapButtonState.toggle()
                            
                        }
                    )
                    
                    CircleButton( // clear grid
                        iconName: "trash"
                        , onClick: {
                            clearBoard()
                        }
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
                .padding(5)
                
                // Play, pause, step
                HStack {
                    CircleButton( // restart from last play
                        iconName: "arrow.counterclockwise"
                        , onClick: {}
                    )
                    
                    ControlBlock( // play / pause controls
                        playing: $customizationManager.playing
                    )
                    
                    CircleButton( // speed controls
                        iconName: "speedometer"
                        , onClick: {}
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(5)
                
                // hide ui, library
                VStack {
                    CircleButton( // hide ui
                        iconName: "eye.slash"
                        , onClick: {}
                    )
                    
                    CircleButton( // library of configs
                        iconName: "text.book.closed"
                        , onClick: {}
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
                .padding(5)
                
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
    
    func clearBoard() {
        self.customizationManager.playing = false
        self.scene.sim.grid = emptyGrid(rows: self.scene.sim.rows, cols: self.scene.sim.cols)
        self.scene.sim.liveCells = []
        self.scene.grid.wipeGrid()
        
    }
}

struct ContentViewArchive_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
