// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class StacksViewModel: ObservableObject {
    @Published var stacks: [NCCommunicationDeckStacks] = []
    
    init(_ stacks: [NCCommunicationDeckStacks]) {
        self.stacks = stacks
    }
    
    func getStackByID(_ stackID: Int) -> NCCommunicationDeckStacks {
        let i = getIndexByStackID(stackID)
        return stacks[i!]
    }
    
    func moveCardInStack(_ card: NCCommunicationDeckCards, _ stackID: Int, sourceIndex: Int, destIndex: Int) {
        if let i = getIndexByStackID(stackID) {
            stacks[i].cards?.remove(at: sourceIndex)
            stacks[i].cards?.insert(card, at: destIndex)
            
            Nextcloud.shared.moveCard(boardID: stacks[i].boardId, stackID: stackID, cardID: card.id, order: destIndex, newStackID: nil)
        }
    }
    
    func insertCardIntoStack(_ card: NCCommunicationDeckCards, stackID: Int, destIndex: Int?) {
        if let i = getIndexByStackID(stackID) {
            if (destIndex != nil) {
                stacks[i].cards?.insert(card, at: destIndex!)
            } else {
                stacks[i].cards?.append(card)
            }
        }
    }
    
    func removeCardFromStack(_ stackID: Int, _ cardIndex: Int) {
        if let i = getIndexByStackID(stackID) {
            stacks[i].cards?.remove(at: cardIndex)
        }
    }
    
    func updateStack(_ boardID: Int, _ stackID: Int, _ cardID: Int, title: String, description: String, order: Int, dueDate: Int?) {
        
    }
    
    private func getIndexByStackID(_ stackID: Int) -> Int? {
        if let i = stacks.firstIndex(where: { $0.id == stackID }) {
            return i
        }
        return nil
    }
}
