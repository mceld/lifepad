//
//  Grid.swift
//  lifepad_game
//
//  Created by GCCISAdmin on 11/3/22.
//

// SKSpriteNode that should render the grid based on the simulation state

import Foundation
import SpriteKit
import SwiftUI

class Grid: SKSpriteNode {

    var rows: Int!
    var cols: Int!
    var blockSize: CGFloat!
    var spriteGrid: [[CellSprite]] = []
    var cellColor: Binding<UIColor>!
    
    convenience init?(blockSize: CGFloat, rows: Int, cols: Int, cellColor: Binding<UIColor>) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.black, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.cellColor = cellColor
        self.isUserInteractionEnabled = true
    }

    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row:Int, col:Int) -> CGPoint {
        // Center point is the midpoint on both axes, adjust the display location
        // based on this center assumption
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0
        return CGPoint(x: x, y: y)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node != self {
//                let action = SKAction.rotate(by:CGFloat.pi*2, duration: 1)
//                node.run(action)
            }
            else {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let row = Int(floor(x / blockSize))
                let col = Int(floor(y / blockSize))
                print("\(row) \(col)")
            }
        }
    }
    
    // Fills the grid with minimum number of sprites
    func populateGrid(sim: Simulation, rows: Int, cols: Int) {
        var tempGrid: [[CellSprite]] = []
        
        for i in 0..<rows {
            
            var tempRow: [CellSprite] = []
            
            for j in 0..<cols {
                
                let cellSprite = CellSprite(size: 10.0, color: cellColor.wrappedValue)
                cellSprite.position = gridPosition(row: i, col: j)
                cellSprite.alive = sim.grid[i][j].state
                addChild(cellSprite)
                tempRow.append(cellSprite)
                
            }
            
            tempGrid.append(tempRow)
        }
        
        spriteGrid = tempGrid
    }
}
