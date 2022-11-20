//
//  ControlButton.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import SwiftUI

struct WrapButton: View {
    @Binding var wrap: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    @State private var wrapIcon = "lock"
    
    func toggleWrap() {
        if(wrap) {
            wrapIcon = "lock"
            wrap = false
        } else {
            wrapIcon = "infinity"
            wrap = true
        }
    }
    
    var body: some View {
        Button(action: {
            toggleWrap()
        }) {
            Image(systemName: wrapIcon)
        }
        .frame(width: 50, height: 50)
        .font(.title)
        .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
        .background(colorScheme == .dark ? darkColor : lightColor)
        .clipShape(Circle())
    }
}
