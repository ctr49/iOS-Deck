// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import Network

struct BoardView: View {
    @State var board: NCCommunicationDeckBoards
    @ObservedObject var viewModel: BoardsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fetchingData: Bool = true
    
    @State private var hasData: Bool = false
    @State private var hasConnection: Bool = false
    
    // network connection monitoring
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @State private var showCard: Bool = false
    @State private var visibleCard: NCCommunicationDeckCards? = nil
    
    var body: some View {
        let boardColor = Color(Color(hex: "#\(board.color)").uiColor().adjust(by: -10)!)
        let hasEditPerm = board.permissions.PERMISSION_EDIT
        
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
                                    StackView(stack: stack, permissionToEdit: (hasConnection && hasEditPerm), viewModel: viewModel.stackModel!, color: boardColor, size: geometry.size)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                        }
                    }
                }
            }
            .sheet(isPresented: $showCard, content: {
                if (visibleCard != nil) {
                    CardView(card: visibleCard!, viewModel: viewModel.stackModel!)
                }
            })
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(hex: "#\(board.color)"))
            .navigationBarTitle(board.title, displayMode: .inline)
            .navigationBarColor(Color(hex: "#\(board.color)").uiColor().adjust(by: -10))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()}, trailing: ReloadView)
            .onAppear(perform: onAppear)
            .onReceive(NotificationCenter.default.publisher(for: .cardSelected), perform: { output in
                let card = output.object as? NCCommunicationDeckCards
                if (card != nil) {
                    visibleCard = card
                    showCard = true
                } else {
                    showCard = false
                    visibleCard = nil
                }
            })
        }
    }
    
    private func onAppear() {
        monitor.pathUpdateHandler = { path in
            hasConnection = (path.status == .satisfied)
            if (hasConnection) {
                getData()
            }
        }
        monitor.start(queue: queue)
        
        let savedStacks = DataManager().getStacks(board.id)
        viewModel.stackModel = StacksViewModel(savedStacks)
        
        if (hasConnection) {
            getData()
        } else {
            hasData = (viewModel.stackModel?.stacks.count ?? 0 > 0)
        }
    }
    
    private func getData() {
        hasData = false
        fetchingData = true
        viewModel.updateStacks(boardID: board.id) {
            (loaded) in
            if (loaded) {
                hasData = (viewModel.stackModel?.stacks.count ?? 0 > 0)
                fetchingData = false
            }
        }
    }
    
    private var ReloadView: some View {
        ZStack {
            if (!hasConnection) {
                Image(systemName: "wifi.exclamationmark")
            } else if (fetchingData) {
                ActivityIndicator(shouldAnimate: $fetchingData)
            } else {
                Button(action: getData) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
