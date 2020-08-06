// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI

struct BoardsView: View {
    
    @ObservedObject var viewModel = BoardsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(viewModel.boards) { board in
                        self.row(forBoard: board)
                    }
                    boardCountView
                }
            }
            .navigationBarTitle("Boards", displayMode: .automatic)
            .navigationBarItems(leading:
                Button("Edit") {
                    print("Edit tapped!")
                },
                trailing:
                Button(action: {
                    print("Add tapped!")
                }) {
                    Image(systemName: "plus")
                }
            )
        }
    }
    
    private func row(forBoard board: BoardsViewModel.Board) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(board.name)
            }
            Spacer()
        }
        .padding()
    }
    
    private var boardCountView: some View {
        Text("Boards: \(viewModel.boards.count)")
    }
}

struct BoardsView_Provider: PreviewProvider {
    static var previews: some View {
        BoardsView()
    }
}
