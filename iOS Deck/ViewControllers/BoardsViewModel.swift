// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

final class BoardsViewModel: ObservableObject {
    @Published var boards: [NCCommunicationBoards] = []
    
    func updateBoards() {
        NextCloud.shared.getBoards() {
            (boards) in
            self.boards = boards
        }
    }
    
}
