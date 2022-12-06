import Foundation

// Holds a limited history of simulation frames in order to support the previous and next buttons
struct StepStack {
    
    let maxFrames: Int = 25 // number of simulations saved
//    private var stackPointer: Int = 0
    var stack: [[[Cell]]] // array of matrices
    
    mutating func pop() -> [[Cell]]? {
        if stack.count > 1 { // there must always be a frame on the stack
            let element = stack.remove(at: 0)
            return element
        }
        return nil
    }
    
    func peek() -> [[Cell]]? {
        if stack.count != 0 {
            return stack[0]
        }
        return nil
    }
    
    mutating func push(element: [[Cell]]) {
        if stack.count >= maxFrames {
            // remove the last item on the stack, shouldn't be empty if maxFrames is greater than 0
            stack.insert(element, at: 0) // put the most recent at the front
            stack.remove(at: stack.count - 1)
        } else {
            stack.insert(element, at: 0)
        }
    }
    
    func peekAt(index: Int) -> [[Cell]]? {
        if stack.count != 0 && index <= stack.count - 1 {
            return stack[index]
        }
        return nil
    }
    
}
