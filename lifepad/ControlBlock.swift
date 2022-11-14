//
//  ControlBlock.swift
//  lifepad
//
//  Created by GCCISAdmin on 11/11/22.
//

import SwiftUI

struct ControlBlock: View {
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    @State private var playPauseIcon: String = "play"
    
    @Binding var playing: Bool
    
    func togglePlaying() {
        if(playing) {
            playPauseIcon = "play"
            playing = false
        } else {
            playPauseIcon = "pause"
            playing = true
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
            }) {
                Image(systemName: "backward.end")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
            // play / pause
            Button(action: {
                togglePlaying()
            }) {
                Image(systemName: playPauseIcon)
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
            Button(action: {
            }) {
                Image(systemName: "forward.end")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
        }
        .background(colorScheme == .dark ? darkColor : lightColor)
        .cornerRadius(25.0)
        
    }
}

//struct ControlBlock_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlBlock()
//    }
//}
