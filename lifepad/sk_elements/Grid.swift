//
// Grid.swift
// SKSpriteNode that should render the grid based on the simulation state
//

// Sources
//
// Bezier stroke source: https://stackoverflow.com/questions/33464925/draw-a-grid-with-spritekit
// Brightness formula source: https://www.w3.org/WAI/ER/WD-AERT/#color-contrast

import Foundation
import SpriteKit
import SwiftUI

// Allow for brightness calculation
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

// Determine whether the grid lines should be black or white based on grid color (not working somewhere else in code)
func findLineColor(color: UIColor) -> UIColor {
    let brightness = ( (color.rgba.red * 299) + (color.rgba.green * 587) + (color.rgba.blue * 114) ) / 1000
    if brightness < 125 { // bright enough to use white lines
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    } else { // bright enough to use black lines
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
}

// Where the simulation is drawn
class Grid: SKSpriteNode {

    var rows: Int!
    var cols: Int!
    var blockSize: CGFloat!
    var cellColor: UIColor!
    var gridColor: UIColor!
    var spriteGrid: [[CellSprite]] = []
    
    // Needs the same information as the GameScene
    convenience init?(blockSize: CGFloat, rows: Int, cols: Int, initCellColor: UIColor, initGridColor: UIColor) {
        guard let texture = gridTexture(blockSize: blockSize,rows: rows, cols:cols, color: findLineColor(color: initGridColor)) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.black, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.cellColor = initCellColor
        self.gridColor = initGridColor
        self.isUserInteractionEnabled = true
    }

    // Determine positioning for drawing the grid
    func gridPosition(row: Int, col: Int) -> CGPoint {
        // Center point is the midpoint on both axes, adjust the display location
        // based on this center assumption
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0
        return CGPoint(x: x, y: y)
    }

    // Handles taps and changes the simulation state accordingly, only works when paused
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let position = touch!.location(in:self)
        let node = atPoint(position)
        if node != self {
            return
        }
        else {
            // turn ui back on if needed
            if((self.parent as! GameScene).customizationManager.uiOpacity == 0.0) {
                (self.parent as! GameScene).customizationManager.uiOpacity = 1.0
                return
            }
            
            // parent is a GameScene
            if(!(self.parent as! GameScene).customizationManager.playing) {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let row = Int(floor(y / blockSize))
                let col = Int(floor(x / blockSize))
                
                self.spriteGrid[row][col].alive.toggle()
            }
        }
    }
    
    // Draw and set the lines as a child of the grid
    func setTexture(color: UIColor) {
        self.texture = gridTexture(blockSize: blockSize, rows: rows, cols: cols, color: color)
    }
    
    // For fitting a preset to the grid, make
    func presetDims(preset: [[Int32]]) -> (rows: Int, cols: Int) {
        // find the max for both the row and col val and return as dimensions
        var rowMax: Int32 = 0
        var colMax: Int32 = 0
        
        for pair in preset {
            if pair[0] > rowMax {
                rowMax = pair[0]
            }
            
            if pair[1] > colMax {
                colMax = pair[1]
            }
        }
        
        return (rows: Int(rowMax), cols: Int(colMax))
    }
    
    // Loads presets and places them in the middle of the simulation grid
    func loadPreset(preset: [[Int32]]) {
        var cells: [Cell] = []
        let dims: (rows: Int, cols: Int) = presetDims(preset: preset)
        
        // ensures that the dimensions do not exceed the size of the grid
        if dims.rows > rows || dims.cols > cols {
            return
        }
        
        for pair in preset {
            cells.append(Cell(state: true, row: Int(pair[0]), col: Int(pair[1])))
        }
        
        wipeGrid()
        
        let originRow = Int(rows / 2) - Int(dims.rows / 2)
        let originCol = Int(cols / 2) - Int(dims.cols / 2)
        
        let offsetRow = max(min(originRow, rows), 0)
        let offsetCol = max(min(originCol, cols), 0)
        
        // draw the preset in (or close to) the center
        for cell in cells {
            spriteGrid[offsetRow + cell.row][offsetCol + cell.col].alive = true
        }
        
    }
    
    // Fills the grid with minimum number of sprites
    // Acts like an init draw
    func populateGrid(grid: [[Cell]], rows: Int, cols: Int) {
        var tempGrid: [[CellSprite]] = []
        
        for i in 0..<rows {
            
            var tempRow: [CellSprite] = []
            
            for j in 0..<cols {
                
                let cellSprite = CellSprite(size: 10.0, color: cellColor)
                cellSprite.position = gridPosition(row: i, col: j)
                cellSprite.alive = grid[i][j].state
                addChild(cellSprite)
                tempRow.append(cellSprite)
                
            }
            
            tempGrid.append(tempRow)
        }
        
        spriteGrid = tempGrid
    }
    
    // un-draw everything
    func wipeGrid() {
        for i in 0..<rows {
            for j in 0..<cols {
                spriteGrid[i][j].alive = false
            }
        }
    }

}

// From source listed at top of file
// Draws a series of Bezier-stroked lines to give the appearance of a dithered grid, easier to see and looks better than straight 1px lines
func gridTexture(blockSize:CGFloat,rows:Int,cols:Int, color: UIColor) -> SKTexture? {
    // Add 1 to the height and width to ensure the borders are within the sprite
    let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
    UIGraphicsBeginImageContext(size)

    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    let bezierPath = UIBezierPath()
    let offset:CGFloat = 0.5
//        let offset:CGFloat = 0.0
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
    // convert UIColor to color and draw/redraw
    SKColor(Color(color)).setStroke()
    bezierPath.lineWidth = 1.0
    bezierPath.stroke()
    context.addPath(bezierPath.cgPath)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return SKTexture(image: image!)
}
