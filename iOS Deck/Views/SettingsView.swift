// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI
import WebKit

struct SettingsView: View {
    @State private var ncURL: String = "https://cloud.purplecloud.xyz"
    @State private var loginURL: String = ""
    
    @State private var displayName: String = "Display Name"
    @State private var avatarURL: String = ""
    
    private let avatarFilePath = getDocumentsDirectory() + "avatar.png"
    
    private let viewController = SettingsViewController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                profileSnippit
                HStack {
                    Text("Login to Nextcloud")
                    Spacer()
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                    }
                }
                .padding(.leading, 10).padding(.trailing, 10)
                
                Spacer()
                
                Button(action: {
                    self.getProfileInfo()
                }) {
                    Text("Get Profile Stuff")
                }
                .padding(5)
                .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
                Button(action: {
                    self.saveToKeychain()
                }) {
                    Text("Write Keychain")
                }
                .padding(5)
                .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
                Button(action: {
                    self.readFromkeychain()
                }) {
                    Text("Read Keychain")
                }
                .padding(5)
                .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
            }
            .onAppear() {
                getProfileInfo()
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
        }
    }
    
    private var profileSnippit: some View {
        VStack {
            Image(uiImage: UIImage(contentsOfFile: self.avatarFilePath) ?? UIImage())
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2.0))
                .frame(width: 90.0, height: 90.0)
            Text(displayName)
        }
    }
    
    private func getProfileInfo() {
        self.viewController.getProfileSegmentInfo() {
            (displayName) in
            self.displayName = displayName
        }
    }
    
    private func saveToKeychain() {
        let user = User(userName: "test", serverURL: "https://cloud.purplecloud.xyz")
        do {
            Settings.currentUser = user
            try AuthController.saveToKeychain(user, password: "BOOBSSSSIES")
        } catch {
            return
        }
    }
    
    private func readFromkeychain() {
        //        guard let currentUser = Settings.currentUser else { return }
        //        print(currentUser)
        guard let auth = AuthController.getLoginFromKeychain else { return }
        print(auth)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
