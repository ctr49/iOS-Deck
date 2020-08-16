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
        NCCommunication.shared.getStacks(boardID: boardID, completionHandler: {
            (account: String, stacks: [NCCommunicationDeckStacks]?, errorCode: Int, errorDescription: String) in
            if (errorCode == 0) {
                closure(stacks!)
            } else {
                print(errorCode, errorDescription)
            }
        })
    }
    
    func moveCard(boardID: Int, stackID: Int, cardID: Int, order: Int, newStackID: Int?) {
        NCCommunication.shared.moveCard(boardID: boardID, stackID: stackID, cardID: cardID, order: order, newStackID: newStackID) {
            (account, card, errorCode, errorDescription) in
            print(errorCode, errorDescription)
        }
    }
}
