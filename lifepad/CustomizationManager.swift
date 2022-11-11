//
//  CustomizationManager.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import Foundation
import UIKit

class CustomizationManager: NSObject, ObservableObject {
    var cellColor: UIColor
    var doWrap: Bool
    
    override init() {
        // load defaults
        self.cellColor = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)
        self.doWrap = false
    }
}
