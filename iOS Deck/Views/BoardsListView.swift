// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct BoardsListView: View {
    @ObservedObject var viewModel: BoardsViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.boards) { board in
                self.row(forBoard: board)
            }
            Text("Boards: \(viewModel.boards.count)")
        }
    }
    
    private func row(forBoard board: NCCommunicationBoards) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(board.title)
            }
            Spacer()
        }
        .padding()
    }
}
