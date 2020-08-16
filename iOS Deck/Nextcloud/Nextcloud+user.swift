// Created for iOS Deck in 2020
// Using Swift 5.0

import NCCommunication

extension Nextcloud {
    func clearUserAvatar() {
        do {
            try FileManager.default.removeItem(atPath: avatarPath)
        } catch {
            print("Error removing avatar", error)
        }
    }
    
    func getUserProfile(closure: @escaping (NCCommunicationUserProfile?) -> Void) {
        NCCommunication.shared.getUserProfile(completionHandler: {
            (account: String, userProfile: NCCommunicationUserProfile?, errorCode: Int, errorDescription: String) in
            closure(userProfile)
        })
    }
    
    
    func downloadAvatar(userID: String) {
        NCCommunication.shared.downloadAvatar(userID: userID, fileNameLocalPath: avatarPath, size: 200) {
            (account: String, data: Data?, errorCode: Int, errorDescription: String) in
        }
    }
}
