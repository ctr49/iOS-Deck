// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import MobileCoreServices

struct CardListItemView: View {
    var card: NCCommunicationDeckCards
    
//    @State private var cardPresented: Bool = false

//    @State private var textLines: Int = 0
//    @State private var checklistLines: Int = 0
//    @State private var checkedLines: Int = 0
//
//    @State private var hasTextLines: Bool = false
//    @State private var hasChecklistLines: Bool = false
//    @State private var hasLabels: Bool = false
    
    var body: some View {
        let (textLines, checklistLines, checkedLines): (Int, Int, Int) = card.getDescriptionNumbers()
        let hasTextLines: Bool = textLines > 0
        let hasChecklistLines: Bool = checklistLines > 0
        let hasLabels: Bool = card.labels?.count ?? 0 > 0
        
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
                    if (hasLabels) {
                        ForEach(card.labels ?? []) {
                            label in
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.init(hex: "#\(label.color)"))
                                .frame(height: 4.5)
                                .padding(.bottom, (hasTextLines || hasChecklistLines) ? -4 : 3)
                        }
                    } else {
                        Spacer()
                            .frame(height: 0)
                    }
                    
                    if (hasTextLines) {
                        Text("") // trick this group into having same height/padding as checklist group
                        Image(systemName: "text.justifyleft")
                            .font(.caption)
                            .padding(.leading, -6)
                    }
                    if (hasChecklistLines) {
                        Text("\(checkedLines)/\(checklistLines)")
                            .font(.caption)
                            .padding(.trailing, -3)
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .padding(.leading, -3)
                    }
                }
                .padding(.bottom, 2)
                .padding(.horizontal, 5)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .onAppear() {
            
        }
        .onTapGesture(count: 1, perform: {
            NotificationCenter.default.post(name: .cardSelected, object: card)
        })
    }
}

extension NCCommunicationDeckCards {
    func getDescriptionNumbers() -> (Int, Int, Int) {
        let lines = self.getDescriptionLines()
        if (lines.count > 0) {
            let checkListLines = lines.filter({ $0.checkListItem != nil })
            let checkedLines = checkListLines.filter({ $0.checkListItem!.checked })
            return (lines.count - checkListLines.count, checkListLines.count, checkedLines.count)
        }
        return (0, 0, 0)
    }
}
