// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct CardView: View {
    @State var card: NCCommunicationDeckCards
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.init(hex: "#181a1b"))
            Group {
                VStack(alignment: .leading) {
                    Text(card.title)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    HStack {
                        Spacer()
                        Button() {
                            print("cog")
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(5)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 1)
    }
}
