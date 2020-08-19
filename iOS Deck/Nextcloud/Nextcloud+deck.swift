// Created for iOS Deck in 2020
// Using Swift 5.0

import NCCommunication

extension Nextcloud {
    func getBoards(closure: @escaping ([NCCommunicationDeckBoards]) -> Void) {
        NCCommunication.shared.getBoards(completionHandler: {
            (account: String, boards: [NCCommunicationDeckBoards]?, errorCode: Int, errorDescription: String) in
            if (errorCode == 0) {
                closure(boards!)
            }
        })
    }
    
    func getStacks(boardID: Int, closure: @escaping ([NCCommunicationDeckStacks]) -> Void) {
        NCCommunication.shared.getStacks(boardID: boardID) {
            (account, stacks, errorCode, errorDescription) in
            if (errorCode == 0) {
                closure(stacks!)
            } else {
                print(errorCode, errorDescription)
            }
        }
    }
    
    func updateCard(_ board: Int, _ card: NCCommunicationDeckCards, closure: @escaping (Bool) -> Void ) {
        NCCommunication.shared.updateCard(boardID: board, card: card) { (account, cards, errorCode, errorDescription) in
            closure(errorCode == 0)
        }
    }
    
//    func getCards(boardID: Int, stackID: Int, closure: @escaping ([NCCommunicationDeckCards]?) -> Void) {
//        NCCommunication.shared.getCards(boardID: boardID, stackID: stackID) {
//            (account, cards, errorCode, errorDescription) in
//            if (errorCode == 0) {
//                closure(cards!)
//            } else {
//                print(errorCode, errorDescription)
//                closure(nil)
//            }
//        }
//    }
    
//    func moveCard(boardID: Int, card: NCCommunicationDeckCards, newStackID: Int?, closure: @escaping (Bool) -> Void) {
//        NCCommunication.shared.reorderCards(boardID: boardID, card: card, order: card.order, newStackID: newStackID) {
//            (account, cards, errorCode, errorDescription) in
//            if (errorCode == 0) {
//                NCCommunication.shared.updateCard(boardID: boardID, card: card) {
//                    (account, card, errorCode, errorDescription) in
//                    if (errorCode == 0) {
//                        closure(true)
//                    } else {
//                        closure(false)
//                    }
//                }
//            } else {
//                closure(false)
//            }
//        }
//    }
}
