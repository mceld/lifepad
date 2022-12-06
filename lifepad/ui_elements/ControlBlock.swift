//
// ControlBlock.swift
// View that holds the play/pause and previous/next controls for the simulation
//

import SwiftUI

struct ControlBlock: View {
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    // For the "grayed out" previous button
    var gray: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    var lightGray: Color = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    @Binding var playing: Bool
    @Binding var stack: StepStack
    
    var previous: () -> Void
    var next: () -> Void
    
    var body: some View {
        HStack(spacing: 1) {
            Button(action: {
                previous()
            }) {
                Image(systemName: "backward.end")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(
                        stack.stack.count <= 1 ? // change to gray if the stack count is at minimum
                        (colorScheme == .dark ? gray : lightGray) : // gray should be different based on the color scheme
                        (colorScheme == .dark ? lightColor : darkColor)
                    )
            }
            
            // play / pause
            Button(action: {
                playing.toggle()
            }) {
                Image(systemName: playing ? "pause" : "play")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
            
            Button(action: {
                next()
            }) {
                Image(systemName: "forward.end")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
        }
        .background(colorScheme == .dark ? darkColor : lightColor)
        .cornerRadius(25.0)
        
    }
}
