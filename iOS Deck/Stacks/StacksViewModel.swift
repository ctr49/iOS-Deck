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
            print(stacks[i].cards!)
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
    
    // updates order for all cards to match index in list
    private func setOrders(_ stackIndex: Int) {
        for (index, card) in stacks[stackIndex].cards!.enumerated() {
            if (index != card.order) { stacks[stackIndex].cards![index].order = index }
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
