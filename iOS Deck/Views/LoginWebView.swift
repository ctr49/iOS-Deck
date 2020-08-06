// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI
import WebKit
import NotificationCenter

struct LoginWebView: View {
    @State var title: String = ""
    @Binding var loginURL: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Webview(url: $loginURL)
            }
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(leading:
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onDisappear() {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private struct Webview: UIViewControllerRepresentable {
        @Binding var url: String
        
        func makeUIViewController(context: Context) -> WebviewController {
            let webviewController = WebviewController()
            
            let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad)
            
            webviewController.webview.load(request)
            
            return webviewController
        }
        
        func updateUIViewController(_ webviewController: WebviewController, context: Context) {
            let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad)
            webviewController.webview.load(request)
        }
    }
}
