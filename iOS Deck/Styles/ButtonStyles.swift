// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

struct RoundButtonStyle: ButtonStyle {
    var bgColor: Color = Color.white
    var fgColor: Color? = Color.black
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(fgColor)
            .padding()
            .background(bgColor)
            .cornerRadius(15.0)
    }
}
