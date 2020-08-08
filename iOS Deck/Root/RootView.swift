// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

struct RootView: View {
    @Binding var notLoggedIn: Bool
    
    @State private var selection = 0
    
    
    var body: some View {
        if (notLoggedIn) {
            LoginView()
        } else {
            Tabs
        }
    }
    
    private var Tabs: some View {
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
