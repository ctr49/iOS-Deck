// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct CardsListView: View {
    @State var cards: [NCCommunicationDeckCards]?
    
    var body: some View {
        ScrollView {
            if (cards == nil) {
                Text("No cards in this stack.")
            } else {
                ForEach(cards!) {
                    card in
                    CardView(card: card)
                }
            }
        }
    }
}
