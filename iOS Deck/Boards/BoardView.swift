// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct BoardView: View {
    @State var board: NCCommunicationDeckBoards
    @ObservedObject var viewModel: BoardsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fetchingData: Bool = true
    
    @State private var hasData: Bool = false
    
    var body: some View {
        let boardColor = Color(Color(hex: "#\(board.color)").uiColor().adjust(by: -10)!)
        GeometryReader {
            geo in
            ZStack {
                if (hasData) {
                    if (viewModel.stackModel == nil) {
                        Text("No Stacks here squad fam")
                    } else {
                        GeometryReader { geometry in
                            TabView() {
                                ForEach(viewModel.stackModel!.stacks) {
                                    stack in
                                    StackView(stack: stack, viewModel: viewModel.stackModel!, color: boardColor, size: geometry.size)
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
            .navigationBarItems(leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()}, trailing: ReloadView)
            .onAppear() {
                let savedStacks = DataManager().getStacks(board.id)
                viewModel.stackModel = StacksViewModel(savedStacks)
                fetchingData = true
                hasData = false
//                hasData = (viewModel.stackModel?.stacks.count ?? 0 > 0)
                
                viewModel.updateStacks(boardID: board.id) {
                    (loaded) in
                    if (loaded) {
                        hasData = (viewModel.stackModel?.stacks.count ?? 0 > 0)
                        fetchingData = false
                    }
                }
                
                
            }
        }
    }
    
    private var ReloadView: some View {
        ZStack {
            if (fetchingData) {
                ActivityIndicator(shouldAnimate: $fetchingData)
            } else {
                Button(){
                    fetchingData = true
                    hasData = false
                    viewModel.updateStacks(boardID: board.id) {
                        (loaded) in
                        if (loaded) {
                            hasData = true
                            fetchingData = false
                        }
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
