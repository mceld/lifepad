//
// CustomizationManager.swift
// Holds UI customization / appearance information and handles communication between main SwiftUI thread and SpriteKit threads
//

import Foundation
import UIKit
import SwiftUI

// Registers changes that can be identified and acted on by SpriteKit loops
struct Controller {
    var clearChange: Bool
    var hideUIChange: Bool
    var loadPreset: [[Int32]]?
    var previous: Bool
    var next: Bool
    var loadLastFrame: Bool // loads the last frame in the stack
}

// Contains all configuration and "Controller" information for the simulation and UI
class CustomizationManager: NSObject, ObservableObject {
    var cellColor: Color
    var gridColor: Color
    @Published var doWrap: Bool
    @Published var playing: Bool
    @Published var uiOpacity: Double
    @Published var speedPercentage: Double
    
    @Published var stepStack: StepStack
    
    var showLibrarySheet: Bool
    var controller: Controller
    
    
    override init() {
        // load defaults
        self.cellColor = Color(red: 1.0, green: 1.0, blue: 1.0)
        self.gridColor = Color(red: 0.0, green: 0.0, blue: 0.0)
        self.doWrap = false
        self.playing = false
        self.uiOpacity = 1.0
        self.speedPercentage = 0.5 // NOTE if you update the default value here, make sure to change the default height of the slider (SpeedSlider.swift)
        self.stepStack = StepStack(stack: [])
        
        self.controller = Controller(
            clearChange: false
            , hideUIChange: false
            , loadPreset: nil
            , previous: false
            , next: false
            , loadLastFrame: false
        )
        self.showLibrarySheet = false
        
    }
}
