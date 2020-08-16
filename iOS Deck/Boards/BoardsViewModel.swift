// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class BoardsViewModel: ObservableObject {
    @Published var boards: [NCCommunicationDeckBoards] = []
    @Published var stackModel: StacksViewModel? = nil
    
    func updateBoards() {
        Nextcloud.shared.getBoards() {
            (boards) in
            self.boards = boards
        }
    }
    
    func updateBoards(closure: @escaping ((_ loaded: Bool) -> Void)) {
        Nextcloud.shared.getBoards() {
            (boards) in
            self.boards = boards
            closure(true)
        }
    }
    
    func updateStacks(boardID: Int, closure: @escaping ((_ loaded: Bool) -> Void)) {
        Nextcloud.shared.getStacks(boardID: boardID) {
            (stacks) in
            self.stackModel = StacksViewModel(stacks)
            closure(true)
        }
    }
}
