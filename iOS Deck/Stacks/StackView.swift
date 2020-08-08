// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct StackView: View {
    @State var stack: NCCommunicationDeckStacks
    @State var color: Color
    @State var height: CGFloat
    @State var width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(color)
            VStack {
                HStack {
                    Text(stack.title).bold()
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                Divider()
                CardsListView(cards: stack.cards)
            }
        }
        .frame(width: width - 40, height: height - 30)
    }
}
