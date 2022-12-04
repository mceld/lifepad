//
//  Library.swift
//  lifepad
//

// most presets come from https://conwaylife.com/wiki/

import SwiftUI

struct Library: View {
    // init environment object thats a list of preset
    var basics: [Preset]
    var ships: [Preset]
    var oscillators: [Preset]
    var misc: [Preset]
    @Binding var showing: Bool
    @Binding var controllerPreset: [[Int32]]?
    
    var body: some View {
        if
            basics.count != 0
            && ships.count != 0
            && oscillators.count != 0
            && misc.count != 0
        {
            List {
                Section(header: Text("Basics")) {
                    ForEach(basics, id: \.self) { preset in
                        PresetCard(preset: preset)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = preset.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Ships")) {
                    ForEach(ships) { preset in
                        PresetCard(preset: preset)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = preset.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Oscillators")) {
                    ForEach(oscillators) { preset in
                        PresetCard(preset: preset)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = preset.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Miscellaneous")) {
                    ForEach(misc) { preset in
                        PresetCard(preset: preset)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = preset.coords
                                    }
                                )
                            )
                    }
                }
            }
        } else {
            Text("No presets to show.")
        }
    }
}

//struct Library_Previews: PreviewProvider {
//    static var previews: some View {
//        Library(showing: true)
//    }
//}
