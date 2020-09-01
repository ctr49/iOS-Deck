// Created for iOS Deck in 2020
// Using Swift 5.0

import Foundation

extension Notification.Name {
    static let loginStatusChanged = Notification.Name("com.cback.auth.changed")
    static let pageLoaded = Notification.Name("com.cback.webview.pageLoaded")
    static let boardLoaded = Notification.Name("com.cback.board.loaded")
    static let boardsLoaded = Notification.Name("com.cback.boards.loaded")
    static let cardSelected = Notification.Name("com.cback.card.selected")
    static let cardUpdated = Notification.Name("com.cback.card.updated")
}
