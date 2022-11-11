//
//  ControlButton.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import SwiftUI

struct CircleButton: View {
    var iconName: String
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    var body: some View {
        Button(action: {
        }) {
            Image(systemName: iconName)
                .frame(width: 50, height: 50)
                .font(.title)
                .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
                .background(colorScheme == .dark ? darkColor : lightColor)
                .clipShape(Circle())
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(iconName: "eye.fill")
    }
}
