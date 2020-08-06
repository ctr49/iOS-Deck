// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

struct RootView: View {
    @State private var notLoggedIn: Bool = false
    @State private var selection = 2
    
    private var nextcloud = NextCloud.shared
    
    var body: some View {
        ZStack {
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
        .onAppear() {
            if (AuthController.isKeychained) {
                // puts keychain auth into Nextcloud API
                nextcloud.setupNCCommFromKeychain()
                notLoggedIn = false
            } else {
                notLoggedIn = true
            }
        }
        .fullScreenCover(isPresented: $notLoggedIn, content: {
            LoginView()
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
