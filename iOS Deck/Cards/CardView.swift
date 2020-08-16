// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import MobileCoreServices

struct CardView: View {
    var card: NCCommunicationDeckCards
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.init(hex: "#181a1b"))
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                .padding(0)
                Text(card.title)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 5)
                VStack {
                    if (card.desc != "") {
                        HStack {
                            Image(systemName: "text.justifyleft")
                            Spacer()
                        }
                        .padding(.bottom, 2)
                    }
                    if (card.labels.count > 0) {
                        HStack {
                            ForEach(card.labels) {
                                label in
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.init(hex: "#\(label.color)"))
                                    .frame(height: 5)
                            }
                        }
                        .padding(.bottom, 2)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
            }
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
    }
}
