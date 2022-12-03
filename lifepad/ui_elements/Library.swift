//
//  Library.swift
//  lifepad
//

import SwiftUI

struct Library: View {
    // init environment object thats a list of preset
    var presets: [Preset]
    @Binding var showing: Bool
    
    var body: some View {
//        ScrollView {
//            Text("Library")
//                .font(.system(.title))
//                .fontWeight(.bold)
        
            if presets.count != 0 {
                List(presets, id: \.self) { preset in
                    PresetCard(libraryShowing: $showing, preset: preset)
                }
            } else {
                Text("No presets to show.")
            }
//        }
//        .padding(20)
        
    }
}

//struct Library_Previews: PreviewProvider {
//    static var previews: some View {
//        Library(showing: true)
//    }
//}
