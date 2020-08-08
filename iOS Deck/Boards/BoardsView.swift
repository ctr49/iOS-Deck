// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI

struct BoardsView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                RefreshScrollView(width: geometry.size.width, height: geometry.size.height)
                    .navigationBarTitle("Boards", displayMode: .automatic)
                    .navigationBarItems(leading:
                                            Button() {
                                                print("Edit tapped!")
                                            } label: {
                                                Text("Edit")
                                                    .foregroundColor(Color.white)
                                            },
                                        trailing:
                                            Button() {
                                                print("Add tapped!")
                                            } label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(Color.white)
                                            }
                    )
                    .accentColor(Color.white)
            }
        }
    }
}
