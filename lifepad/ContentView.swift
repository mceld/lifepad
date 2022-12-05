// Main view holding all Lifepad controls and scenes
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview
// https://stackoverflow.com/questions/68365480/pass-share-class-with-spriteview-gamescene-from-a-swiftui-view // State and environment
// https://stackoverflow.com/questions/38865788/moving-camera-in-spritekit-swift


// https://thecoderpilot.blog/2020/10/21/building-an-ios-version-of-the-conways-game-of-life/ // main resource
//https://www.youtube.com/watch?v=-pok--jpGIQ&ab_channel=StewartLynch // magnification gesture
// https://www.youtube.com/watch?v=2ZK5wfbvvS4&ab_channel=StewartLynch // drag gesture
// https://www.youtube.com/watch?v=6MHoN6mdfB0&ab_channel=DevTechie // constraining zoom


/////////////////////////
// TODO
// fix fitting of ui to screen // DONE
// MARK: actually change the speed

// next / previous and return to last play
// Color controls, pane with color picker



// improvements to hiding UI / making grid and sprite outline clear
// calculating grid lines color based on bgcolor
// no smudging on gesture
/////////////////////////


import SwiftUI
import SpriteKit

struct ContentView: View {
    let CONST_PADDING = 2.0
    let CONST_SPACING = 2.0
    
    @EnvironmentObject var presetsModel: PresetsModel
    @StateObject var customizationManager = CustomizationManager()
    
    // dragging
    @State private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    // zooming
    @State private var currentScale = 1.0
    @GestureState private var pinchValue = 1.0
    private let minScale = 1.0
    private let maxScale = 4.0
    
    // library sheet
    @State private var showLibrary = false
    
    // showing speed slider
    @State var sliderAnimate: Bool = false
    
    var scene: GameScene {
        let game = GameScene(customizationManager: customizationManager)
        return game
    }
    
    func constrainZoom(magnification: CGFloat) -> CGFloat {
        return max(min(self.currentScale * magnification, maxScale), self.minScale)
    }
    
    var body: some View {
        ZStack(alignment: .leading) { // Overlay controls on grid
            
            SpriteView(scene: scene)
                .equatable()
                .offset(x: dragOffset.width + position.width, y: dragOffset.height + position.height)
                .scaleEffect(constrainZoom(magnification: pinchValue))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded({ gesture in
                            position.width += gesture.translation.width
                            position.height += gesture.translation.height
                            dragOffset = CGSize.zero
                        })
                )
                .gesture(
                    MagnificationGesture()
                        .updating($pinchValue, body: { (value, state, _) in
                            state = value
                        })
                        .onEnded({ (value) in
                            currentScale = constrainZoom(magnification: value)
                        })
                )
            
            
            HStack(alignment: .center, spacing: CONST_SPACING) { // Control Group
                
                // customization, wrap, clear grid
                VStack(spacing: CONST_SPACING) {
                    CircleButton( // customize color
                        iconName: "paintpalette"
                        , onClick: {
//                            print(customizationManager)
//                            self.customizationManager.cellColor =
//                            UIColor(
//                                red: Double.random(in: 0...1.0)
//                                , green: Double.random(in: 0...1.0)
//                                , blue: Double.random(in: 0...1.0)
//                                , alpha: 1.0
//                            )
                        }
//                        // TODO change this to redraw the grid with the color changes only
                    )
//                    VStack(alignment: .center, spacing: 0) {
//                        ColorPicker("", selection: $customizationManager.cellColor, supportsOpacity: false)
//                        ColorPicker("", selection: $customizationManager.gridColor, supportsOpacity: false)
//                    }
//                    .padding(0)
                        
                    CircleButton(
                        iconName: customizationManager.doWrap ? "infinity" : "lock"
                        , onClick: {
                            self.customizationManager.doWrap.toggle()
                        }
                    )
                    
                    CircleButton( // clear grid
                        iconName: "trash"
                        , onClick: {
                            self.customizationManager.playing = false
                            self.customizationManager.controller.clearChange = true
                        }
                    )
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
                .padding(CONST_PADDING)
                
//                Spacer()
                
                // Play, pause, step
                HStack(alignment: .bottom, spacing: CONST_SPACING) {
                    CircleButton( // restart from last play
                        iconName: "arrow.counterclockwise"
                        , onClick: {
                            scene.changeSpeed(fps: 1)
                        }
                    )
                    
                    ControlBlock( // play / pause controls
                        playing: $customizationManager.playing
                    )
                    
                    VStack(spacing: CONST_SPACING) {
                        SpeedSlider(percentage: $customizationManager.sleepPercentage, sliderAnimate: $sliderAnimate)
                            .padding(0)
                        CircleButton( // speed controls
                            iconName: sliderAnimate ? "xmark" : "speedometer"
                            , onClick: {
                                withAnimation(Animation.spring().speed(1)) {
                                    sliderAnimate.toggle()
                                }
                            }
                        )
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(CONST_PADDING)
                
//                Spacer()
                
                // hide ui, library
                VStack(spacing: CONST_SPACING) {
                    CircleButton( // hide ui
                        iconName: "eye.slash"
                        , onClick: {
                            self.customizationManager.controller.hideUIChange = true
                        }
                    )
                    
                    CircleButton( // reset zoom and drag
                        iconName: "dot.arrowtriangles.up.right.down.left.circle"
                        , onClick: {
                            currentScale = 1.0
                            dragOffset = CGSize.zero
                            position = CGSize.zero
                        })
                    
                    CircleButton( // library of configs
                        iconName: "text.book.closed"
                        , onClick: {
                            showLibrary.toggle()
                        }
                    )
                    .sheet(isPresented: $showLibrary) {
                        Library(
                            basics: presetsModel.basics.data
                            , ships: presetsModel.ships.data
                            , oscillators: presetsModel.oscillators.data
                            , misc: presetsModel.misc.data
                            , showing: $showLibrary
                            , controllerPreset: $customizationManager.controller.loadPreset
                        )
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
                .padding(CONST_PADDING)
                
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .bottom
            )
            .opacity(customizationManager.uiOpacity)
            .padding(CONST_PADDING)
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
        .statusBarHidden(true)
        .padding(0)
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
