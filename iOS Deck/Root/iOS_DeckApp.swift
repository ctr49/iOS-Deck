// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import CoreData

@main
struct iOS_DeckApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @State var notLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            RootView(notLoggedIn: $notLoggedIn)
                .onAppear() {
                    setAuth()
                }
                .onReceive(NotificationCenter.default.publisher(for: .loginStatusChanged)) { _ in
                    setAuth()
                }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                print("background")
//                saveContext()
            default:
                print("default")
            }
        }
    }
    
    private func setAuth() {
        if (AuthController.isKeychained) {
            Nextcloud.shared.setupNCCommFromKeychain()
            self.notLoggedIn = false
        } else {
            self.notLoggedIn = true
        }
    }
}
