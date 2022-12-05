//
//  CustomizationManager.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import Foundation
import UIKit
import SwiftUI

struct Controller {
    var clearChange: Bool
    var hideUIChange: Bool
    var loadPreset: [[Int32]]?
    var previous: Bool
    var next: Bool
    var lastPlay: Bool
}

class CustomizationManager: NSObject, ObservableObject {
    var cellColor: Color
    var gridColor: Color
    @Published var doWrap: Bool
    @Published var playing: Bool
    @Published var uiOpacity: Double
    @Published var speedPercentage: Double
    
    @Published var stepStack: StepStack
    @Published var stackPointer: Int
    @Published var lastPlay: [[CellSprite]]?
    
    var showLibrarySheet: Bool
    var controller: Controller
    
    override init() {
        // load defaults
        self.cellColor = Color(red: 1.0, green: 1.0, blue: 1.0)
        self.gridColor = Color(red: 0.0, green: 0.0, blue: 0.0)
        self.doWrap = false
        self.playing = false
        self.uiOpacity = 1.0
        self.showLibrarySheet = false
        self.controller = Controller(
            clearChange: false
            , hideUIChange: false
            , loadPreset: nil
            , previous: false
            , next: false
            , lastPlay: false
        )
        // NOTE if you update the default value here, make sure to change the default height of the slider (SpeedSlider.swift)
        self.speedPercentage = 0.5
        
        // stack initialization
        self.stepStack = StepStack(stack: [])
        self.stackPointer = 0
        self.lastPlay = nil
    }
    
//    // moves the stack pointer back once
//    mutating func back() {
//        stackPointer -= 1
//    }
//
//    // moves the stack pointer forward once
//    mutating func next() {
//        stackPointer += 1
//    }
    
    func movePointerBack() {
        stackPointer = min(stepStack.maxFrames, max(0, stackPointer - 1))
    }
    
    override var description: String {
        var result: String = ""
        
        result += "cellColor: " + self.cellColor.description + "\n"
        result += "gridColor: " + self.gridColor.description + "\n"
        result += "doWrap: " + String(self.doWrap) + "\n"
        result += "playing: " + String(self.playing) + "\n"
        
        return result
    }
}
