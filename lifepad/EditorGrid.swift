//
//  EditorGrid.swift
//  Lifepad
//
//  Created by GCCISAdmin on 10/27/22.
//

//
// MARK: ARCHIVE
// Archive of SwiftUI attempt, non-functional
//


import SwiftUI

struct EditorGrid: View {
    
    // Simulation state
    let length: Int
    let width: Int
    
    @Binding var sim: Simulation
    @State var scale = 3.0
    @State var lastScale = 3.0
    @State var minScale = 3.0
    @State var maxScale = 16.0
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { newScale in
                let delta = newScale / lastScale
                scale = validateScale(s: scale * delta)
                lastScale = newScale
                print(scale)
            }
            .onEnded { newScale in
                lastScale = scale
            }
    }
    
    func validateScale(s: CGFloat) -> CGFloat {
        if(s > maxScale) {
            return maxScale
        } else if(s < minScale) {
            return minScale
        }
        return s
    }
    
    
    // Cosmetics
    @Binding var doWrap: Bool
    
//    @State private var zoomScale: CGFloat
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            VStack(spacing: 0) {
                // May need to / use rectangles for only the liveCells, or use some lower level pixel drawing routine
                ForEach(0..<length, id: \.self) { l in
                    HStack(spacing: 0) {
                        ForEach(0..<width, id: \.self) { w in
                            Rectangle()
                                .foregroundColor(sim.grid[l][w].state ? Color.blue : Color.white)
//                                .foregroundColor(Color.blue)
                                .frame(width: scale, height: scale)
                                .border(Color.gray, width: 0.1)
                        }
                    } // HStack, Row of Rectangles
                }
            }
        }
        .scaleEffect(scale)
        .gesture(magnification)
    }
}
