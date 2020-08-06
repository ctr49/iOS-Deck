// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import SwiftUI
import NCCommunication

class SettingsViewController {
    public static let shared: SettingsViewController = {
        let instance = SettingsViewController()
        return instance
    }()
    
    let nextcloud = NextCloud.shared
    
    func getProfileSegmentInfo(closure: @escaping (_ displayName: String) -> Void) {
        nextcloud.getUserProfile() {
            (userProfile: NCCommunicationUserProfile?) in
            guard let userProfile = userProfile else { return }
            
            self.nextcloud.downloadAvatar(userID: userProfile.userId)
            
            closure(userProfile.displayName)
        }
    }
}
