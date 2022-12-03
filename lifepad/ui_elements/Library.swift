//
//  Library.swift
//  lifepad
//

import SwiftUI

struct Library: View {
    // init environment object thats a list of preset
    var basics: [Preset]
    var advanced: [Preset]
//    var hideSheet: () -> Void
    @Binding var showing: Bool
    
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
