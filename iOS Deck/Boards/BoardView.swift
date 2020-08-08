// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct BoardView: View {
    @State var board: NCCommunicationDeckBoards
    @ObservedObject var viewModel: BoardsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var loading: Bool = true
    
    var body: some View {
        ZStack {
            if (loading) {
                ActivityIndicator(shouldAnimate: $loading)
            } else {
                GeometryReader { geometry in
                    TabView() {
                        ForEach(viewModel.selectedStacks) { stack in
                            StackView(stack: stack, color: Color(Color(hex: "#\(board.color)").uiColor().adjust(by: -10)!), height: geometry.size.height, width: geometry.size.width)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
            }
        }
        .navigationBarTitle(board.title, displayMode: .inline)
        .navigationBarColor(Color(hex: "#\(board.color)").uiColor().adjust(by: -10))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()})
        .background(Color(hex: "#\(board.color)"))
        .onAppear() {
            viewModel.updateStacks(boardID: board.id) {
                (loaded) in
                if (loaded) {
                    board.stacks = viewModel.selectedStacks
                    loading = false
                }
            }
        }
    }
}
