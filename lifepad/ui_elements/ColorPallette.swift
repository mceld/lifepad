//
// ColorPallette.swift
// Pop-up view that holds color pickers and allow for simulation grid customization
//

import SwiftUI

struct ColorPallette: View {
    
    @Binding var cellColor: Color
    @Binding var gridColor: Color
    
    @Binding var palletteAnimate: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ColorPicker("Alive", selection: $cellColor, supportsOpacity: false)
                .padding(0)
                .frame(width: 100)
                .font(.system(size: 12))
            ColorPicker("Dead" , selection: $gridColor, supportsOpacity: false)
                .padding(0)
                .frame(width: 100)
                .font(.system(size: 12))
        }
        .frame(width: 150, height: 100)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(25)
        .padding(0)
        .opacity(palletteAnimate ? 1.0 : 0.0)
    }
}
