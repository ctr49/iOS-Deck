// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class StacksViewModel: ObservableObject {
    @Published var stacks: [NCCommunicationDeckStacks] = []
    @Published var board: NCCommunicationDeckBoards? = nil
    
    init(_ stacks: [NCCommunicationDeckStacks]) {
        self.stacks = stacks
    }
    
    func getStackByID(_ stackID: Int) -> NCCommunicationDeckStacks {
        let i = getIndexByStackID(stackID)
        return stacks[i!]
    }
    
    func moveCardInStack(_ card: NCCommunicationDeckCards, sourceIndex: Int, destIndex: Int) {
        if let i = getIndexByStackID(card.stackId) {
            card.order = destIndex
            stacks[i].cards?.remove(at: sourceIndex)
            stacks[i].cards?.insert(card, at: destIndex)
            setOrders(i)
            
            DataManager().setStack(stacks[i])
            SyncManager.shared.SyncStackCards(stacks[i])
        }
    }
    
    func insertCardIntoStack(_ card: NCCommunicationDeckCards, stackID: Int, destIndex: Int?) {
        if let i = getIndexByStackID(stackID) {
            if (destIndex != nil) {
                card.order = destIndex!
                card.stackId = stackID
                stacks[i].cards?.insert(card, at: destIndex!)
            } else {
                if (stacks[i].cards != nil) {
                    card.order = stacks[i].cards!.count - 1
                    card.stackId = stackID
                    stacks[i].cards?.append(card)
                } else {
                    card.order = 0
                    card.stackId = stackID
                    stacks[i].cards = [card]
                }
            }
            setOrders(i)
            
            DataManager().setStack(stacks[i])
            SyncManager.shared.SyncStackCards(stacks[i])
        }
    }
    
    func removeCardFromStack(_ stackID: Int, _ cardIndex: Int) {
        if let i = getIndexByStackID(stackID) {
            stacks[i].cards?.remove(at: cardIndex)
            setOrders(i)
            
            DataManager().setStack(stacks[i])
            SyncManager.shared.SyncStackCards(stacks[i])
        }
    }
    
    func updateDescriptionCheckbox(stackID: Int, cardID: Int, _ value: Bool, range: Range<String.Index>) {
        if let stackIndex = getIndexByStackID(stackID) {
            if let cardIndex = stacks[stackIndex].cards?.firstIndex(where: { $0.id == cardID }) {
                stacks[stackIndex].cards![cardIndex].desc.replaceSubrange(range, with: value ? "- [x]" : "- [ ]")
            }
        }
    }
    
    func syncCard(_ card: NCCommunicationDeckCards) {
        if let (stackIndex, cardIndex) = getCardIndexesByID(card.id) {
            DataManager().setStack(stacks[stackIndex])
            SyncManager.shared.SyncCard(stacks[stackIndex].cards![cardIndex], boardID: stacks[stackIndex].boardId)
        }
    }
    
    func getCardIndexesByID(_ cardID: Int) -> (stackIndex: Int, cardIndex: Int)? {
        let stack = stacks.firstIndex(where: {
            if ($0.cards != nil) {
                return ($0.cards!.first(where: { $0.id == cardID }) != nil)
            }
            return false
        })
        if (stack != nil) {
            let card = stacks[stack!].cards!.firstIndex(where: { $0.id == cardID })
            if (card != nil) {
                return (stack!, card!)
            }
        }
        return nil
    }
    
    // updates order for all cards to match index in list
    private func setOrders(_ stackIndex: Int) {
        for (index, card) in stacks[stackIndex].cards!.enumerated() {
            if (index != card.order) { stacks[stackIndex].cards![index].order = index }
        }
    }
    
    private func getIndexByStackID(_ stackID: Int) -> Int? {
        if let i = stacks.firstIndex(where: { $0.id == stackID }) {
            return i
        }
        return nil
    }
}
