// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import MobileCoreServices

struct StackView: View {
    @State var stack: NCCommunicationDeckStacks
    @State var permissionToEdit: Bool
    @ObservedObject var viewModel: StacksViewModel
    @State var color: Color
    @State var size: CGSize
    
    var body: some View {
        let stackIndex = viewModel.stacks.firstIndex(where: { $0.id == stack.id })!
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(color)
            VStack {
                HStack {
                    Text(stack.title).bold()
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                Divider()
                    .background(Color.white)
                
                StackListView(stack: viewModel.stacks[stackIndex], viewModel: viewModel, permissionToEdit: permissionToEdit)
                    .padding(.bottom, 0)
                
                Divider()
                    .background(Color.white)
                    .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: (size.width - 35), minHeight: 0, idealHeight: 0, maxHeight: (size.height - 30))
    }
}
