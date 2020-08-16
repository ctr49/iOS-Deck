// Created for ios-deck in 2020
// Using Swift 5.0

import NCCommunication

class Nextcloud {
    public static let shared: Nextcloud = {
        let instance = Nextcloud()
        return instance
    }()
    
    let avatarPath = getDocumentsDirectory("avatar.png")
}
