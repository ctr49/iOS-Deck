// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class BoardsViewModel: ObservableObject {
    @Published var boards: [NCCommunicationDeckBoards] = []
    
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
        let index = boards.firstIndex { $0.id == boardID }
        if (index != nil) {
            NextCloud.shared.getStacks(boardID: boardID) {
                (stacks) in
                self.boards[index!].stacks = stacks
                closure(true)
            }
        }
    }
}
