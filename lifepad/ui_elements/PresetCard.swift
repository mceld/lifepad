//
// PresetCard.swift
// Displays a single preset, image, name, and description
//

import SwiftUI

struct PresetCard: View {
    
    var preset: Preset
    
    var body: some View {
        HStack {
            // image
            Image(preset.image)
                .resizable()
                .frame(maxWidth: 50, maxHeight: 50)
//                .padding(5)
            // Name (as title)
            VStack {
                Text(preset.name)
                    .font(.system(.title))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(preset.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            // make it clickable -> close the sheet, wipe the grid, and draw the preset from the list of coords
        }
    }
}
