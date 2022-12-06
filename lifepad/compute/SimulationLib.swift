//
// SimuationLib.swift
// Contains functions for creating, manipulating, and printing a Conway's game of life simulation
//

import Foundation
import UIKit

struct Cell {
    var state: Bool
    var row: Int
    var col: Int
}

extension Cell: CustomStringConvertible {
    var description: String {
        if state {
            return "@"
        }
        return "."
    }
}

// Initialize a grid of dead cells length * width in size
func emptyGrid(rows: Int, cols: Int) -> [[Cell]] {
    var grid: [[Cell]] = []
    
    for row in 0..<rows {
        var rowCells: [Cell] = []
        
        for col in 0..<cols {
            rowCells.append(Cell(state: false, row: row, col: col))
        }
        
        grid.append(rowCells)
    }
    
    return grid
}

func randomGrid(rows: Int, cols: Int) -> [[Cell]] {
    var grid = emptyGrid(rows: rows, cols: cols)
    for i in 0..<rows {
        for j in 0..<cols {
            if(Int.random(in: 1..<9) == 1) {
                grid[i][j].state = true
            }
        }
    }
    return grid
}

// Neighbors are constant (1 cell in every direction of the current)
func makeNeighborCoords() -> [(Int, Int)] {
    let neighborCoords: [(vertical: Int, horizontal: Int)] = [
        (vertical: 0, horizontal: 1)
        , (vertical: 1, horizontal: 0)
        , (vertical: 1, horizontal: 1)
        , (vertical: 0, horizontal: -1)
        , (vertical: -1, horizontal: 0)
        , (vertical: -1, horizontal: -1)
        , (vertical: -1, horizontal: 1)
        , (vertical: 1, horizontal: -1)
    ]
    
    return neighborCoords
}

// Turns an index that would go off the grid to the other size
func wrap(size: Int, num: Int) -> Int {
    return ( size + num ) % size
}

// Accounts for wrapping and determines the intended index of the current neighbor cell
func determineNeighborIndex(size: Int, num: Int, offset: Int, doWrap: Bool) -> Int {
    // if we are about to go off the grid in the positive or negative direction
    if(num + offset > size - 1 || num + offset < 0) {
        if(doWrap) {
            return wrap(size: size, num: num + offset)
        }
        return -1 // we are about to go off the grid but don't want to wrap
    }
    
    return num + offset
}

// Returns a list of cells that are neighbors of the cell at (cellRow, cellCol).  Accounts for wrapping
func getNeighbors(
    cellRow: Int
    , cellCol: Int
    , rows: Int
    , cols: Int
    , grid: [[CellSprite]]
    , doWrap: Bool
    , neighborCoords: [(vertical: Int, horizontal: Int)]
) -> [CellSprite] {
    var neighbors: [CellSprite] = []
    
    // Check all neighbors -> determine if the row or col value exceeds or goes below the max or 0
    // if that's true, check doWrap, add the neighbor at the wrapped coord if it's on
    // don't add a neighbor at all if it's off the grid
    
    for coord in neighborCoords {
        
        let vIndex = determineNeighborIndex(size: rows, num: cellRow, offset: coord.vertical, doWrap: doWrap)
        let hIndex = determineNeighborIndex(size: cols, num: cellCol, offset: coord.horizontal, doWrap: doWrap)
        
        // Don't add an off the grid neighbor
        if(vIndex == -1 || hIndex == -1) {
            continue
        }
        
        neighbors.append(grid[vIndex][hIndex])
        
    }
    
    return neighbors
}

// Counts the number of live neighbors in a given list of cells
func getLiveNeighbors(neighbors: [CellSprite]) -> Int {
    var count = 0
    
    for neighbor in neighbors {
        if(neighbor.alive) {
            count += 1
        }
    }
    
    return count
}

// Calculates the next generation of cells based on Conway's rules
// Live: 2 or 3 live neighbors -> stay alive, otherwise: die.
// Dead: 3 live neighbors -> become alive, otherwise: stay dead.
func nextGen(
    cellGrid: [[CellSprite]]
    , rows: Int
    , cols: Int
    , doWrap: Bool
    , neighborCoords: [(Int, Int)]
) -> [[Cell]] {
    var returnGrid = emptyGrid(rows: rows, cols: cols)

    for i in 0..<rows {
        for j in 0..<cols {

            let cell = cellGrid[i][j]
            let neighbors = getNeighbors(cellRow: i, cellCol: j, rows: rows, cols: cols, grid: cellGrid, doWrap: doWrap, neighborCoords: neighborCoords)
            let liveNeighbors = getLiveNeighbors(neighbors: neighbors)

            if (cell.alive) { // live
                if(liveNeighbors == 2 || liveNeighbors == 3) {
                    returnGrid[i][j].state = true
                }
            } else { // dead
                if(liveNeighbors == 3) {
                    returnGrid[i][j].state = true
                }
            }
        }
    }
    return returnGrid
}
