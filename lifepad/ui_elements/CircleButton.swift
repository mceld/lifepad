//
// CircleButton
// General, styled button view that supports any onClick action, fits the intended style, and changes with the device's color theme
//

import SwiftUI

struct CircleButton: View {
    var iconName: String
    var onClick: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    var body: some View {
        Button(action: {
            onClick()
        }) {
            Image(systemName: iconName)
                .padding(5)
        }
        .frame(width: 50, height: 50)
        .font(.title)
        .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
        .background(colorScheme == .dark ? darkColor : lightColor)
        .clipShape(Circle())
    }
}
