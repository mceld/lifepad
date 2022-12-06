//
// CellSprite.swift
// Used for drawing cells where there are cells in the simulation
// Overlayed on grid
//

import Foundation
import SpriteKit

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
        self.isUserInteractionEnabled = true
    }
    
    // required by swiftc
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Alter the state of the simulation (make a live cell dead) when the user taps
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let position = touch!.location(in: self)
        let node = atPoint(position)
        if node != self {
            return
        } else {
            // turn ui back on if needed
            if((self.parent?.parent as! GameScene).customizationManager.uiOpacity == 0.0) {
                (self.parent?.parent as! GameScene).customizationManager.uiOpacity = 1.0
                return
            }
            
            // CellSprite's parent is Grid, Grid's parent is GameScene
            if(!(self.parent?.parent as! GameScene).customizationManager.playing) {
                // an alive cell is being touched, set it to dead
                self.alive = false
            }
        }
    }
}
