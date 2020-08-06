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
    
    let nextcloud = NextCloud.shared
    private var pollTimer: Timer?
    
    private var endpoint: String = ""
    private var token: String = ""
    private var counter: Int = 0
    
    func startPollLoop(endpoint: String, token: String) {
        self.counter = 0
        self.endpoint = endpoint
        self.token = token
        
        NotificationCenter.default.addObserver(self, selector: #selector(spontaniousPoll), name: Notification.Name("pageLoaded"), object: nil)
//        pollTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(scheduledPoll), userInfo: nil, repeats: true)
    }
    
    @objc func spontaniousPoll() {
        pollAppPassword(spontanious: true)
    }
    
    @objc private func scheduledPoll() {
        pollAppPassword(spontanious: false)
    }
    
    private func pollAppPassword(spontanious: Bool) {
        if (!spontanious) {
            self.counter += 1
            if (self.counter > 15) {
                killPollLoop()
                return
            }
        }
        
        // call out to the endpoint and check if the token has been authenticated
        nextcloud.pollAppPassword(endpoint: self.endpoint, token: self.token) {
            (server, loginName, appPassword) in
            
            guard let server = server else { return }
            guard let loginName = loginName else { return }
            guard let appPassword = appPassword else { return }
            
            let user = User(userName: loginName, serverURL: server)
            
            // save current user to userDefaults, save username and password to keychain, and give username, password, and serverURL to Nextcloud API instance
            do {
                Settings.currentUser = user
                try AuthController.saveToKeychain(user, password: appPassword)
                self.nextcloud.setupNextcloud(server: server, login: loginName, password: appPassword)
            } catch {
                fatalError("fatal error saving to keychain")
            }
            self.killPollLoop()
        }
    }
    
    func killPollLoop() {
        pollTimer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func getLoginURLRequest(url: String, closure: @escaping (String, String, String) -> Void) {
        nextcloud.getLoginRequestURL(url: url) {
            (loginURL, token, endpoint) in
            guard let loginURL = loginURL else { return }
            guard let token = token else { return }
            guard let endpoint = endpoint else { return }
            
            closure(loginURL, token, endpoint)
        }
    }
}
