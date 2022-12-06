//
// Library.swift
// List view that holds loadable presets, fit for use with a bottom sheet
//

// Sources
//
// Presets from https://conwaylife.com/wiki/

import SwiftUI

struct Library: View {
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
                    ForEach(basics, id: \.self) { basic in
                        PresetCard(preset: basic)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = basic.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Ships")) {
                    ForEach(ships, id: \.self) { ship in
                        PresetCard(preset: ship)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = ship.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Oscillators")) {
                    ForEach(oscillators, id: \.self) { osc in
                        PresetCard(preset: osc)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = osc.coords
                                    }
                                )
                            )
                    }
                }
                
                Section(header: Text("Miscellaneous")) {
                    ForEach(misc, id: \.self) { misc in
                        PresetCard(preset: misc)
                            .gesture(TapGesture()
                                .onEnded(
                                    { _ in
                                        // launch the preset
                                        showing = false
                                        controllerPreset = misc.coords
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
