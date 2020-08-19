// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI
import WebKit

struct SettingsView: View {
    @State private var ncURL: String = "https://cloud.purplecloud.xyz"
    @State private var loginURL: String = ""
    
    @State private var displayName: String = "Display Name"
    @State private var avatarURL: String = ""
    
    private let avatarFilePath = getDocumentsDirectory("avatar.png")
    
    private let viewController = SettingsViewController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                profileSnippit
    
                Spacer()
                
                Button() {
                    self.getProfileInfo()
                } label: {
                    Text("Get Profile Stuff")
                }
                .padding(5)
                .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
                Button() {
                    DataManager().resetData().deleteDataFile()
                } label: {
                    Text("Reset Cache")
                }
                .padding(5)
                .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
            }
            .onAppear() {
                getProfileInfo()
            }
            .navigationBarTitle("Settings", displayMode: .automatic)
            .navigationBarItems(trailing: logoutButton)
        }
    }
    
    private var logoutButton: some View {
        Button() {
            viewController.logout()
        } label: {
            Text("Log Out")
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
