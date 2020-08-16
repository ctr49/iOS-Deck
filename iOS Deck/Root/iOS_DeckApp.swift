// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI

@main
struct iOS_DeckApp: App {
    // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    @State var notLoggedIn: Bool = false
    
    private var nextcloud = Nextcloud.shared
    
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
    }
    
    private func setAuth() {
        if (AuthController.isKeychained) {
            nextcloud.setupNCCommFromKeychain()
            self.notLoggedIn = false
            //presentationMode.wrappedValue.dismiss()
            print(self.$notLoggedIn)
        } else {
            self.notLoggedIn = true
        }
    }
    
}
