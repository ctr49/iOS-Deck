// Created for iOS Deck in 2020
// Using Swift 5.0

import NCCommunication

extension Nextcloud {
    func getLoginRequestURL(url: String, closure: @escaping (String?, String?, String?) -> Void) {
        NCCommunication.shared.getLoginFlowV2(serverUrl: url) {
            (token: String?, endpoint: String?, login: String?, errorCode: Int, errorDescription: String) in
            
            closure(login, token, endpoint)
        }
    }
    
    func pollAppPassword(endpoint: String, token: String, closure: @escaping (String?, String?, String?) -> Void) {
        NCCommunication.shared.getLoginFlowV2Poll(token: token, endpoint: endpoint) {
            (server: String?, loginName: String?, appPassword: String?, errorCode: Int, errorDescription: String) in
            
            closure(server, loginName, appPassword)
        }
    }

    func setupNextcloud(server: String, login: String, password: String) {
        NCCommunicationCommon.shared.setup(account: "\(server)/\(login)", user: login, userId: login, password: password, url: server)
    }
    
    func setupNCCommFromKeychain() {
        if (AuthController.isKeychained) {
            let auth = AuthController.getLoginFromKeychain!
            let user = auth.user
            self.setupNextcloud(server: user.serverURL, login: user.userName, password: auth.password)
        }
    }
    
    func clearSetup(_ currentUser: User) {
        NCCommunicationCommon.shared.remove(account: "\(currentUser.serverURL)/\(currentUser.userName)")
        setupNextcloud(server: currentUser.serverURL, login: "", password: "")
    }
}
