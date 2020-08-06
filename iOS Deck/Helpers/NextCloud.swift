// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

class NextCloud {
    public static let shared: NextCloud = {
        let instance = NextCloud()
        return instance
    }()
    
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
            print("Keychained bb")
            
            let auth = AuthController.getLoginFromKeychain!
            let user = auth.user
            self.setupNextcloud(server: user.serverURL, login: user.userName, password: auth.password)
        }
    }
    
    func getUserProfile(closure: @escaping (NCCommunicationUserProfile?) -> Void) {
        nextcloud.getUserProfile(completionHandler: {
            (account: String, userProfile: NCCommunicationUserProfile?, errorCode: Int, errorDescription: String) in
            closure(userProfile)
        })
    }
    
    func downloadAvatar(userID: String) {
        let filename = getDocumentsDirectory() + "photos/avatar.png"
        print(filename)
        nextcloud.downloadAvatar(userID: userID, fileNameLocalPath: filename, size: 200) {
            (account: String, data: Data?, errorCode: Int, errorDescription: String) in
            print(filename)
            print("Code: \(errorCode) - \(errorDescription)")
        }
    }
}
