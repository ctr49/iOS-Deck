// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

final class BoardsViewModel: ObservableObject {
    struct Board: Identifiable {
        var id = UUID()
        var name: String
    }
    
    @Published var boards = [Board(name: "Nadion"), Board(name: "Hookbuffer"), Board(name: "TVBot")]
    
}
