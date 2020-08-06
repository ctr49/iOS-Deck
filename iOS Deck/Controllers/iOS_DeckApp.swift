// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

@main
struct iOS_DeckApp: App {
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }

}
