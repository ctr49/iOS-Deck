// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

struct TabView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            BoardsView()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Boards")
                    }
                }
                .tag(0)
            UpcommingView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Due")
                    }
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
