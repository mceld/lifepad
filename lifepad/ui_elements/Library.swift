//
//  Library.swift
//  lifepad
//

// most presets come from https://conwaylife.com/wiki/

import SwiftUI

struct Library: View {
    // init environment object thats a list of preset
    var basics: [Preset]
    var advanced: [Preset]
    @Binding var showing: Bool
    @Binding var controllerPreset: [[Int32]]?
    
    var body: some View {
        if basics.count != 0 && advanced.count != 0  {
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
                
                Section(header: Text("Advanced")) {
                    ForEach(advanced) { preset in
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
