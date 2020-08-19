// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import MobileCoreServices

struct CardView: View {
    var card: NCCommunicationDeckCards
    
    var body: some View {
        let hasLabels: Bool = card.labels?.count ?? 0 > 0
        let hasDescription: Bool = card.desc != ""
        let labelPadding: CGFloat = (hasDescription) ? -4 : 4
        
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.init(hex: "#181a1b"))
            VStack(alignment: .leading) {
                Text(card.title)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 5)
                    .padding(.top, 3)
                Spacer()
                HStack {
                    if (hasDescription) {
                        Image(systemName: "text.justifyleft")
                            .padding(.bottom, 4)
                    }
                    if (hasLabels) {
                        ForEach(card.labels ?? []) {
                            label in
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.init(hex: "#\(label.color)"))
                                .frame(height: 4.5)
                                .padding(.bottom, labelPadding)
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
    }
}
