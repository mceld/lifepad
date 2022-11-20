// Contains functions for creating, manipulating, and printing a Conway's game of life simulation

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

class Simulation: NSObject, ObservableObject {
    var rows: Int
    var cols: Int
    var grid: [[Cell]]
    var liveCells: [Cell]
    
    init(rows: Int, cols: Int, grid: [[Cell]], liveCells: [Cell]) {
        self.rows = rows
        self.cols = cols
        self.grid = grid
        self.liveCells = liveCells
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

func randomizeGrid(sim: Simulation) {
    for i in 0..<sim.rows {
        for j in 0..<sim.cols {
            if(Int.random(in: 1..<9) == 1) {
                sim.grid[i][j].state = true
                sim.liveCells.append(sim.grid[i][j])
            }
        }
    }
}

func initRandomSim(rows: Int, cols: Int) -> Simulation {
    let sim = Simulation(
        rows: rows
        , cols: cols
        , grid: emptyGrid(
            rows: rows
            , cols: cols
        )
        , liveCells: []
    )
    randomizeGrid(sim: sim)
    return sim
}

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

func wrap(size: Int, num: Int) -> Int {
    return ( size + num ) % size
}

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

func getNeighbors(
    cell: Cell
    , sim: Simulation
    , doWrap: Bool
    , neighborCoords: [(vertical: Int, horizontal: Int)]
) -> [Cell] {
    
    let rows: Int = sim.rows
    let cols: Int = sim.cols
    let grid: [[Cell]] = sim.grid
    
    var neighbors: [Cell] = []
    
    // Check all neighbors -> determine if the row or col value exceeds or goes below the max or 0
    // if that's true, check doWrap, add the neighbor at the wrapped coord if it's on
    // don't add a neighbor at all if it's off
    
    for coord in neighborCoords {
        
        let vIndex = determineNeighborIndex(size: rows, num: cell.row, offset: coord.vertical, doWrap: doWrap)
        let hIndex = determineNeighborIndex(size: cols, num: cell.col, offset: coord.horizontal, doWrap: doWrap)
        
        // Don't add an off the grid neighbor
        if(vIndex == -1 || hIndex == -1) {
            continue
        }
        
        neighbors.append(grid[vIndex][hIndex])
        
    }
    
    return neighbors
}

func getLiveNeighbors(neighbors: [Cell]) -> Int {
    var count = 0
    
    for neighbor in neighbors {
        if(neighbor.state) {
            count += 1
        }
    }
    
    return count
}

func getSalientCells(
    sim: Simulation
    , doWrap: Bool
    , neighborCoords: [(vertical: Int, horizontal: Int)]
) -> [Cell] {
    // Get the combination of liveCells and the dead neighbors of liveCells
    var salientCells = sim.liveCells
    for cell in sim.liveCells {
        
        // find every neighbor
        let neighbors = getNeighbors(
            cell: cell
            , sim: sim
            , doWrap: doWrap
            , neighborCoords: neighborCoords
        )
        
        // add only the dead neighbors
        for neighbor in neighbors {
            if neighbor.state == false {
                salientCells.append(neighbor)
            }
        }
    }
    
    return salientCells
}

func nextGen(
    sim: Simulation
    , doWrap: Bool
    , neighborCoords: [(Int, Int)]
) -> Simulation {
    let returnSim = Simulation(rows: sim.rows, cols: sim.cols, grid: emptyGrid(rows: sim.rows, cols: sim.cols), liveCells: [])
    
    for i in 0..<sim.rows {
        for j in 0..<sim.cols {
            
            let cell = sim.grid[i][j]
            let neighbors = getNeighbors(cell: cell, sim: sim, doWrap: doWrap, neighborCoords: neighborCoords)
            let liveNeighbors = getLiveNeighbors(neighbors: neighbors)
            
            if (cell.state) { // live
                if(liveNeighbors == 2 || liveNeighbors == 3) {
                    returnSim.grid[i][j].state = true
                    returnSim.liveCells.append(returnSim.grid[i][j])
                }
            } else { // dead
                if(liveNeighbors == 3) {
                    returnSim.grid[i][j].state = true
                    returnSim.liveCells.append(returnSim.grid[i][j])
                }
            }
        }
    }
    return returnSim
}

// // // //
// MARK: ARCHIVE
// // // //

//func nextGen(
//    sim: Simulation
//    , doWrap: Bool
//    , neighborCoords: [(vertical: Int, horizontal: Int)]
//) -> Simulation {
//    var newGrid: [[Cell]] = emptyGrid(length: sim.length, width: sim.width)
//    var newLiveCells: [Cell] = []
//    let salientCells: [Cell] = getSalientCells(sim: sim, doWrap: doWrap, neighborCoords: neighborCoords)
//
//    // Loop over all salient cells (live cells and their dead neighbors)
//    // do things differently if the cell is alive or dead
//    for var salientCell in salientCells {
//        let neighbors = getNeighbors(
//            cell: salientCell
//            , sim: sim
//            , doWrap: doWrap
//            , neighborCoords: neighborCoords
//        )
//
//        // Apply Conway's rules
//        // Live cells live only if they have 2 or 3 neighbors
//        // Dead cells become live if they have exactly 3 neighbors
//        // Live cells should be added to the newLiveCells list
//
//        let liveNeighbors: Int = getLiveNeighbors(neighbors: neighbors)
//
//        if (salientCell.state) { // live
//            if(liveNeighbors == 2 || liveNeighbors == 3) {
//                newLiveCells.append(salientCell)
//            }
//        } else { // dead
//            if(liveNeighbors == 3) {
//                salientCell.state = true // Dead cell lives!
//                newLiveCells.append(salientCell)
//            }
//        }
//
//    }
//
//    // Add all live cells for the next generation to the new grid
//    for newLiveCell in newLiveCells {
//        newGrid[newLiveCell.row][newLiveCell.col].state = newLiveCell.state
//    }
//
//    // Return the newly constructed simulation
//    return Simulation(length: sim.length, width: sim.width, grid: newGrid, liveCells: newLiveCells)
//
//}

//extension Simulation: CustomStringConvertible {
//    var description: String {
//        var result: String = ""
//
//        for i in 0..<rows {
//            for j in 0..<cols {
//                if(grid[i][j].state == true) {
//                    result += "@"
//                } else {
//                    result += "."
//                }
//            }
//            result += "\n"
//        }
//
//        return result
//    }
//}
