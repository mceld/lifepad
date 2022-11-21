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

struct ContentView: View {
    @StateObject var customizationManager = CustomizationManager()
    
//    @State private var dragOffset = CGSize.zero
//    @State private var currentScale = 1.0
//    @State private var lastScale = 1.0
//
//    private let minScale = 1.0
//    private let maxScale = 4.0
//    private let zoomSpeed: CGFloat = 0.5
    
    var scene: GameScene {
        let game = GameScene(customizationManager: customizationManager)
        return game
    }
    
    
    
    var body: some View {
        ZStack { // Overlay controls on grid
            SpriteView(scene: scene)
                .equatable()
//                .offset(dragOffset)
//                .scaleEffect(currentScale)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
////                            let newX = max(0, gesture.translation)
//                            dragOffset = gesture.translation
//                            print(dragOffset)
//                        }
////                        .onEnded({ gesture in
////                            dragOffset = CGSize.zero
////                        })
//                )
//                .gesture(
//                    MagnificationGesture()
//                        .onChanged { amount in
////                            currentScale = amount - 1
//                            var deltaScale = amount
//                            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
//                            deltaScale = min(deltaScale, maxScale)
//                            deltaScale = max(deltaScale, minScale)
//                            currentScale = deltaScale
//                        }
//                        .onEnded { amount in
//                            lastScale = currentScale
////                            currentScale = 0
////                            print(finalScale)
//                        }
//                )
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
                    ColorPicker("", selection: $customizationManager.gridColor)
                    
                    WrapButton( // wrap grid
                        wrap: $customizationManager.doWrap
                    )
                    
                    CircleButton( // clear grid
                        iconName: "trash"
                        , onClick: {
                            self.customizationManager.controller.clearChange = true
                        }
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
//                .padding(5)
                
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
//                .padding(5)
                
                // hide ui, library
                VStack {
                    CircleButton( // hide ui
                        iconName: "eye.slash"
                        , onClick: {
                            self.customizationManager.controller.hideUIChange = true
                        }
                    )
                    
                    CircleButton( // library of configs
                        iconName: "text.book.closed"
                        , onClick: {}
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
//                .padding(5)
                
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .bottom
            )
            .opacity(customizationManager.uiOpacity)
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
        .statusBarHidden(true)
    }
}

extension SpriteView: Equatable {
    public static func == (lhs: SpriteView, rhs: SpriteView) -> Bool {
        return true
    }
}

struct ContentViewArchive_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
