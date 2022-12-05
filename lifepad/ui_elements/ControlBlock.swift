import SwiftUI

struct ControlBlock: View {
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    @State private var playPauseIcon: String = "play"
    @Binding var playing: Bool
    
    var onPlay: () -> Void
    var previous: () -> Void
    var next: () -> Void
    
    var body: some View {
        HStack(spacing: 1) {
            Button(action: {
                previous()
            }) {
                Image(systemName: "backward.end")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
            // play / pause
            Button(action: {
                playing.toggle()
                onPlay()
            }) {
                Image(systemName: playing ? "pause" : "play")
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
            }
            Button(action: {
                next()
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
