//
// StepStack.swift
// Holds a limited history of simulation frames in order to support the previous, next, and rewind/undo buttons
//

import Foundation

struct StepStack {
    
    let maxFrames: Int = 25 // Number of simulation frames saved
    var stack: [[[Cell]]] // Array of matrices (containing Cell structs)
    
    mutating func pop() -> [[Cell]]? {
        if stack.count > 1 { // There must always be a frame on the stack, don't pop down to an empty stack
            let element = stack.remove(at: 0)
            return element
        }
        return nil
    }
    
    // Gets the top element of the stack
    func peek() -> [[Cell]]? {
        if stack.count != 0 {
            return stack[0]
        }
        return nil
    }
    
    // Places an element on the stack and shrinks the size if necessary
    mutating func push(element: [[Cell]]) {
        if stack.count >= maxFrames {
            // Remove the last item on the stack, shouldn't be empty if maxFrames is greater than 0
            stack.insert(element, at: 0) // Put the most recent at the front
            stack.remove(at: stack.count - 1) // Remove the last element to make room
        } else {
            stack.insert(element, at: 0)
        }
    }
    
    // For the rewind / undo button, returns last simulation frame in the history
    func bottom() -> [[Cell]]? {
        if stack.count > 0 {
            return stack[stack.count - 1]
        }
        return nil
    }
    
}
