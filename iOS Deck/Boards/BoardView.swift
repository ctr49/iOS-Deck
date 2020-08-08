// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct BoardView: View {
    @State var board: NCCommunicationDeckBoards
    var viewModel: BoardsViewModel
    
    @State private var shouldAnimate = true
    
    var body: some View {
        ZStack {
            ActivityIndicator(shouldAnimate: $shouldAnimate)
            TabView {
                ForEach(board.stacks) { stack in
                    Text(stack.title)
                    Divider()
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .navigationBarTitle(board.title, displayMode: .inline)
        .navigationBarColor(Color(hex: "#\(board.color)").uiColor().adjust(by: -10))
        .background(Color(hex: "#\(board.color)"))
        .onAppear() {
            viewModel.updateStacks(boardID: board.id) {
                (loaded) in
                if (loaded) {
                    shouldAnimate = false
                }
            }
        }
    }
}
