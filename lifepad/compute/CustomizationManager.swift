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
}

class CustomizationManager: NSObject, ObservableObject {
    var cellColor: Color
    var gridColor: Color
    var doWrap: Bool
    var playing: Bool
    var uiOpacity: Double
    
    var controller: Controller
    
    override init() {
        // load defaults
        self.cellColor = Color(red: 1.0, green: 1.0, blue: 1.0)
        self.gridColor = Color(red: 0.0, green: 0.0, blue: 0.0)
        self.doWrap = false
        self.playing = false
        self.uiOpacity = 1.0
        self.controller = Controller(
            clearChange: false
            , hideUIChange: false
        )
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
