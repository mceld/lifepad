//
//  CustomizationManager.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import Foundation
import UIKit
import SwiftUI

class CustomizationManager: NSObject, ObservableObject {
//    var cellColor: UIColor
//    var gridColor: UIColor
    var cellColor: Color
    var gridColor: Color
    var doWrap: Bool
    var playing: Bool
    
    override init() {
        // load defaults
//        self.cellColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.gridColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.cellColor = Color(red: 1.0, green: 1.0, blue: 1.0)
        self.gridColor = Color(red: 1.0, green: 1.0, blue: 1.0)
        self.doWrap = false
        self.playing = false
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