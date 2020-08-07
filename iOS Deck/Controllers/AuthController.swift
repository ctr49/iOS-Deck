// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

class AuthController {
    
    static let serviceName = "iOSDeckService"
    
    static var isKeychained: Bool {
        guard let currentUser = Settings.currentUser else {
            return false
        }
        
        do {
            let password = try KeychainPasswordItem(service: serviceName, account: currentUser.userName).readPassword()
            return password.count > 0
        } catch {
            return false
        }
    }
    
    static var getLoginFromKeychain: UserAuth? {
        guard let currentUser = Settings.currentUser else {
            return nil
        }
        
        do {
            let password = try KeychainPasswordItem(service: serviceName, account: currentUser.userName).readPassword()
            return UserAuth(user: currentUser, password: password)
        } catch {
            return nil
        }
    }
    
    class func login(_ user: User, password: String) throws {
        try KeychainPasswordItem(service: serviceName, account: user.userName).savePassword(password)
        
        Settings.currentUser = user
        NextCloud.shared.downloadAvatar(userID: user.userName)
        
        NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
    }
    
    class func logout() throws {
        guard let currentUser = Settings.currentUser else {
            return
        }
        
        try KeychainPasswordItem(service: serviceName, account: currentUser.userName).deleteItem()
        
        NextCloud.shared.clearSetup(currentUser)
        NextCloud.shared.clearUserAvatar()
        Settings.currentUser = nil
        
        NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
    }
    
}
