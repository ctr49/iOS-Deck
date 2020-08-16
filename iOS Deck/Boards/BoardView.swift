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
        let boardColor = Color(Color(hex: "#\(board.color)").uiColor().adjust(by: -10)!)
        GeometryReader {
            geo in
            ZStack {
                if (loading) {
                    ActivityIndicator(shouldAnimate: $loading)
                } else {
                    if (viewModel.stackModel == nil) {
                        Text("No Stacks here squad fam")
                    } else {
                        GeometryReader { geometry in
                            TabView() {
                                ForEach(viewModel.stackModel!.stacks.indices) { index in
                                    StackView(index: index, viewModel: viewModel.stackModel!, color: boardColor, size: geometry.size)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                        }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(hex: "#\(board.color)"))
            .navigationBarTitle(board.title, displayMode: .inline)
            .navigationBarColor(Color(hex: "#\(board.color)").uiColor().adjust(by: -10))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()}, trailing:
                                    Button(){
                                        loading = true
                                        viewModel.updateStacks(boardID: board.id) {
                                            (loaded) in
                                            if (loaded) {
                                                loading = false
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "arrow.clockwise")
                                    })
            .onAppear() {
                viewModel.updateStacks(boardID: board.id) {
                    (loaded) in
                    if (loaded) {
                        loading = false
                    }
                }
            }
        }
    }
}
