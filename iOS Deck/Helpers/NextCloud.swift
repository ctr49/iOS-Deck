// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

class NextCloud {
    public static let shared: NextCloud = {
        let instance = NextCloud()
        return instance
    }()
    
    private let avatarPath = getDocumentsDirectory("avatar.png")
    
    private let nextcloud = NCCommunication.shared
    private let common = NCCommunicationCommon.shared
    
    func getLoginRequestURL(url: String, closure: @escaping (String?, String?, String?) -> Void) {
        nextcloud.getLoginFlowV2(serverUrl: url) {
            (token: String?, endpoint: String?, login: String?, errorCode: Int, errorDescription: String) in
            
            closure(login, token, endpoint)
        }
    }
    
    func pollAppPassword(endpoint: String, token: String, closure: @escaping (String?, String?, String?) -> Void) {
        nextcloud.getLoginFlowV2Poll(token: token, endpoint: endpoint) {
            (server: String?, loginName: String?, appPassword: String?, errorCode: Int, errorDescription: String) in
            
            closure(server, loginName, appPassword)
        }
    }
    
    func setupNextcloud(server: String, login: String, password: String) {
        common.setup(account: "\(server)/\(login)", user: login, userId: login, password: password, url: server)
    }
    
    func setupNCCommFromKeychain() {
        if (AuthController.isKeychained) {
            let auth = AuthController.getLoginFromKeychain!
            let user = auth.user
            self.setupNextcloud(server: user.serverURL, login: user.userName, password: auth.password)
        }
    }
    
    func clearSetup(_ currentUser: User) {
        common.remove(account: "\(currentUser.serverURL)/\(currentUser.userName)")
        setupNextcloud(server: currentUser.serverURL, login: "", password: "")
    }
    
    func clearUserAvatar() {
        do {
            try FileManager.default.removeItem(atPath: avatarPath)
        } catch {
            print("Error removing avatar", error)
        }
    }
    
    func getUserProfile(closure: @escaping (NCCommunicationUserProfile?) -> Void) {
        nextcloud.getUserProfile(completionHandler: {
            (account: String, userProfile: NCCommunicationUserProfile?, errorCode: Int, errorDescription: String) in
            closure(userProfile)
        })
    }
    
    
    func downloadAvatar(userID: String) {
        nextcloud.downloadAvatar(userID: userID, fileNameLocalPath: avatarPath, size: 200) {
            (account: String, data: Data?, errorCode: Int, errorDescription: String) in
        }
    }
    
    func getBoards(closure: @escaping ([NCCommunicationDeckBoards]) -> Void) {
        nextcloud.getBoards(completionHandler: {
            (account: String, boards: [NCCommunicationDeckBoards]?, errorCode: Int, errorDescription: String) in
            if (errorCode == 0) {
                closure(boards!)
            }
        })
    }
    
    func getStacks(boardID: Int, closure: @escaping ([NCCommunicationDeckStacks]) -> Void) {
        nextcloud.getStacks(boardID: boardID, completionHandler: {
            (account: String, stacks: [NCCommunicationDeckStacks]?, errorCode: Int, errorDescription: String) in
            if (errorCode == 0) {
                closure(stacks!)
            } else {
                print(errorCode, errorDescription)
            }
        })
    }
}
