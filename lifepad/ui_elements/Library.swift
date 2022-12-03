//
//  Library.swift
//  lifepad
//

import SwiftUI

struct Library: View {
    // init environment object thats a list of preset
    @Binding var showing: Bool
    
    var body: some View {
        ScrollView {
            Text("Library")
                .font(.system(.title))
                .fontWeight(.bold)
            
            Divider()
            
            ForEach(0..<10) { preset in
                LibraryPreset()
            }
        }
        .padding(20)
        
    }
}

//struct Library_Previews: PreviewProvider {
//    static var previews: some View {
//        Library(showing: true)
//    }
//}
