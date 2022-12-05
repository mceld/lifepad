// https://medium.com/devtechie/opacity-animation-in-swiftui-d7c38e3cc494
// slider opacity animation

import SwiftUI

// custom slider inspired by https://stackoverflow.com/questions/58286350/how-to-create-custom-slider-by-using-swiftui

struct SpeedSlider: View {

    @State var dragOffset = 0.0
    @State var sliderHeight = 150 * 0.5 // if changing the initial height, change the initial percentage, not best practice but makes the gesture code easier to understand
    
    @Binding var percentage: Double
    @Binding var sliderAnimate: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var darkColor: Color = Color(red: 0.0, green: 0.0, blue: 0.0)
    var lightColor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)

    var body: some View {
        ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? darkColor : lightColor)
                    .frame(width: 50, height: 150)
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? lightColor : darkColor)
                    .frame(width: 50, height: max(0, min(sliderHeight + dragOffset, 150)), alignment: .bottom)
            }
            .cornerRadius(25)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    dragOffset = value.translation.height * -1
                })
                .onEnded({ gesture in
                    sliderHeight = min(150, max(0, dragOffset + sliderHeight))
                    dragOffset = CGFloat.zero
                    percentage = sliderHeight / 150
                })
            )
            .opacity(sliderAnimate ? 1.0 : 0.0)
        
    }
}

//extension Slider {
//    track
//}
