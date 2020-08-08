// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class BoardsViewModel: ObservableObject {
    @Published var boards: [NCCommunicationDeckBoards] = []
    @Published var selectedStacks: [NCCommunicationDeckStacks] = []
    
//    func setSelectedBoard(_ boardID: Int) {
//        let index = boards.firstIndex { $0.id == boardID }
//        if (index != nil) {
//            selectedStacks = boards[index!]
//        }
//    }
    
    func updateBoards() {
        NextCloud.shared.getBoards() {
            (boards) in
            self.boards = boards
        }
    }
    
    func updateBoards(closure: @escaping ((_ loaded: Bool) -> Void)) {
        NextCloud.shared.getBoards() {
            (boards) in
            self.boards = boards
            closure(true)
        }
    }
    
    func updateStacks(boardID: Int, closure: @escaping ((_ loaded: Bool) -> Void)) {
        NextCloud.shared.getStacks(boardID: boardID) {
            (stacks) in
            self.selectedStacks = stacks
            closure(true)
        }
    }
}
