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
    }
}
