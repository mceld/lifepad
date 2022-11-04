// Contains functions for creating, manipulating, and printing a Conway's game of life simulation

import Foundation

func makeNeighborCoords() -> [(Int, Int)] {
    var neighborCoords: [(Int, Int)] = []
    
    for i in -1...1 {
        for j in -1...1 {
            neighborCoords.append((vertical: i, horizontal: j))
        }
    }
    
    return neighborCoords
}

struct Cell {
    var state: Bool
    var row: Int
    var col: Int
}

// Initialize a grid of dead cells length * width in size
func emptyGrid(length: Int, width: Int) -> [[Cell]] {
    var grid: [[Cell]] = []
    
    for row in 0...length {
        var rowCells: [Cell] = []
        
        for col in 0...width {
            rowCells.append(Cell(state: false, row: row, col: col))
        }
        
        grid.append(rowCells)
    }
    
    return grid
}

class Simulation {
    var length: Int
    var width: Int
    var grid: [[Cell]]
    var liveCells: [Cell] // Might be better to make this a set
    
    init(length: Int, width: Int, grid: [[Cell]], liveCells: [Cell]) {
        self.length = length
        self.width = width
        self.grid = grid
        self.liveCells = liveCells
    }
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
    
    let length: Int = sim.length
    let width: Int = sim.width
    let grid: [[Cell]] = sim.grid
    
    var neighbors: [Cell] = []
    
    // Check all neighbors -> determine if the row or col value exceeds or goes below the max or 0
    // if that's true, check doWrap, add the neighbor at the wrapped coord if it's on
    // don't add a neighbor at all if it's off
    
    for coord in neighborCoords {
        
        let vIndex = determineNeighborIndex(size: length, num: cell.row, offset: coord.vertical, doWrap: doWrap)
        let hIndex = determineNeighborIndex(size: width, num: cell.col, offset: coord.horizontal, doWrap: doWrap)
        
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
    , neighborCoords: [(vertical: Int, horizontal: Int)]
) -> Simulation {
    var newGrid: [[Cell]] = emptyGrid(length: sim.length, width: sim.width)
    var newLiveCells: [Cell] = []
    let salientCells: [Cell] = getSalientCells(sim: sim, doWrap: doWrap, neighborCoords: neighborCoords)
    
    // Loop over all salient cells (live cells and their dead neighbors)
    // do things differently if the cell is alive or dead
    for var salientCell in salientCells {
        let neighbors = getNeighbors(
            cell: salientCell
            , sim: sim
            , doWrap: doWrap
            , neighborCoords: neighborCoords
        )
        
        // Apply Conway's rules
        // Live cells live only if they have 2 or 3 neighbors
        // Dead cells become live if they have exactly 3 neighbors
        // Live cells should be added to the newLiveCells list
        
        let liveNeighbors: Int = getLiveNeighbors(neighbors: neighbors)

        if (salientCell.state) { // live
            if(liveNeighbors == 2 || liveNeighbors == 3) {
                newLiveCells.append(salientCell)
            }
        } else { // dead
            if(liveNeighbors == 3) {
                salientCell.state = true // Dead cell lives!
                newLiveCells.append(salientCell)
            }
        }
                
    }
    
    // Add all live cells for the next generation to the new grid
    for newLiveCell in newLiveCells {
        newGrid[newLiveCell.row][newLiveCell.col].state = newLiveCell.state
    }
        
    // Return the newly constructed simulation
    return Simulation(length: sim.length, width: sim.width, grid: newGrid, liveCells: newLiveCells)
    
}

extension Simulation: CustomStringConvertible {
    var description: String {
        var result: String = ""
        
        for i in 0..<length {
            for j in 0..<width {
                if(grid[i][j].state == true) {
                    result += "@"
                } else {
                    result += "."
                }
            }
            result += "\n"
        }
        
        return result
    }
}


