// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI

struct LoginView: View {
    @State private var ncURL: String = ""
    @State private var loginURL: String = ""
    
    @State private var token: String = ""
    @State private var endpoint: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showWebView: Bool = false
    
    
    private let viewController = LoginViewController.shared
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    Image(uiImage: UIImage(named: "NextcloudIconWhite")!)
                        .padding(.top, 0)
                    Text("Connect to Nextcloud to access your Deck")
                        .foregroundColor(Color.white)
                    TextField("Nextcloud URL", text: $ncURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.login()
                    }) {
                        Text("Connect to NextCloud")
                    }
                    .buttonStyle(RoundButtonStyle(bgColor: Color.white, fgColor: Color.black))
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                }
            }
            .fullScreenCover(isPresented: $showWebView, onDismiss: dismiss) {
                LoginWebView(title: ncURL, loginURL: $loginURL, isPresented: $showWebView)
                    .onAppear() {
                        viewController.startPageChangeListener(endpoint: endpoint, token: token)
                    }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            Spacer()
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func login() {
        self.viewController.getLoginURLRequest(url: self.ncURL) {
            (loginURL, token, endpoint) in
            self.loginURL = loginURL
            self.token = token
            self.endpoint = endpoint
            self.showWebView = true
        }
    }
    
    private func dismiss() -> Void {
        presentationMode.wrappedValue.dismiss()
    }
}
