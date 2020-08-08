// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation
import SwiftUI
import NCCommunication

class LoginViewController {
    public static let shared: LoginViewController = {
        let instance = LoginViewController()
        return instance
    }()
    
    private var endpoint: String = ""
    private var token: String = ""
    
    func startPageChangeListener(endpoint: String, token: String) {
        self.endpoint = endpoint
        self.token = token
        
        NotificationCenter.default.addObserver(self, selector: #selector(pollAppPassword), name: .pageLoaded, object: nil)
    }
    
    @objc private func pollAppPassword() {
        // call out to the endpoint and check if the token has been authenticated
        NextCloud.shared.pollAppPassword(endpoint: self.endpoint, token: self.token) {
            (server, loginName, appPassword) in
            
            guard let server = server else { return }
            guard let loginName = loginName else { return }
            guard let appPassword = appPassword else { return }
            
            let user = User(userName: loginName, serverURL: server)
            
            // save current user to userDefaults, save username and password to keychain, and give username, password, and serverURL to Nextcloud API instance
            do {
                Settings.currentUser = user
                try AuthController.login(user, password: appPassword)
                NextCloud.shared.setupNextcloud(server: server, login: loginName, password: appPassword)
            } catch {
                fatalError("fatal error saving to keychain")
            }
            self.killPageChangeListener()
        }
    }
    
    func killPageChangeListener() {
        print("killing")
        NotificationCenter.default.removeObserver(self)
    }
    
    func getLoginURLRequest(url: String, closure: @escaping (String, String, String) -> Void) {
        NextCloud.shared.getLoginRequestURL(url: url) {
            (loginURL, token, endpoint) in
            guard let loginURL = loginURL else { return }
            guard let token = token else { return }
            guard let endpoint = endpoint else { return }
            
            closure(loginURL, token, endpoint)
        }
    }
}
