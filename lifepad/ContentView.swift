// Main view holding all Lifepad controls and scenes
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview
// https://stackoverflow.com/questions/68365480/pass-share-class-with-spriteview-gamescene-from-a-swiftui-view // State and environment
// https://stackoverflow.com/questions/38865788/moving-camera-in-spritekit-swift

// TODO
// Editing the grid, how to manage race condition?
// Wiping the grid
// Speed controls
// Color controls, pane with color picker


// Hide UI -> grid lines should be toggled, stroke of cellsprites set to clear

import SwiftUI
import SpriteKit

func initSim(rows: Int, cols: Int) -> Simulation {
    var sim = Simulation(
        rows: rows
        , cols: cols
        , grid: emptyGrid(
            rows: rows
            , cols: cols
        )
        , liveCells: []
    )
    randomizeGrid(sim: sim)
    return sim
}

struct ContentView: View {
    @StateObject var customizationManager = CustomizationManager()
    
    @State var wrapButtonState: Bool = false
    @State private var dragOffset = CGSize.zero
    @State private var currentScale = 1.0
    @State private var lastScale = 1.0
    
    let rows = Int(round(UIScreen.main.bounds.height / 7.5))
    let cols = Int(round(UIScreen.main.bounds.width / 7.5))
    
    // TODO need to fix state management for simulation so it isn't redrawn with every gesture
    @StateObject var simulation: Simulation
    
    private let minScale = 1.0
    private let maxScale = 4.0
    private let zoomSpeed: CGFloat = 0.5
    
    var scene: GameScene {
        let game = GameScene(sim: simulation, rows: rows, cols: cols, customizationManager: customizationManager)
//        game.scaleMode = .aspectFill
        
//        let camera = SKCameraNode()
//        camera.position = CGPoint(x: game.frame.midX, y: game.frame.midY)
//        game.addChild(camera)
        
        return game
    }
    
    
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene)
                .offset(dragOffset)
                .scaleEffect(currentScale)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
//                            let newX = max(0, gesture.translation)
                            dragOffset = gesture.translation
                            print(dragOffset)
                        }
//                        .onEnded({ gesture in
//                            dragOffset = CGSize.zero
//                        })
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { amount in
//                            currentScale = amount - 1
                            var deltaScale = amount
                            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
                            deltaScale = min(deltaScale, maxScale)
                            deltaScale = max(deltaScale, minScale)
                            currentScale = deltaScale
                        }
                        .onEnded { amount in
                            lastScale = currentScale
//                            currentScale = 0
//                            print(finalScale)
                        }
                )
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
