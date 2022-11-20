import Foundation
import SpriteKit
import SwiftUI

// Used for drawing cells where there are cells in the simulation
// Overlayed on grid

class CellSprite: SKShapeNode {
    
    var alive: Bool = false {
        didSet {
            isHidden = !alive // toggle visibility
        }
    }
    
    init(size: CGFloat, color: UIColor) {
        super.init()
        self.path = CGPath(rect: CGRect(x: 0, y: 0, width: size, height: size), transform: nil)
        self.fillColor = color
//        self.strokeColor = .clear
    }
    
    // required by swiftc
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
