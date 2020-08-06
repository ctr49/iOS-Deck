// Created for iOS Deck in 2020
// Using Swift 5.0

import UIKit
import WebKit
import NotificationCenter

class WebviewController: UIViewController {
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webview.frame = self.view.frame
        self.view.addSubview(self.webview)

        self.view.addSubview(self.progressbar)
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.progressbar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.progressbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.progressbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        self.progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }

    // MARK: - Handle Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress": // handles blue loading indicator
            if self.webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressbar.alpha = 0.0
                }, completion: { finished in
                    self.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressbar.isHidden = false
                self.progressbar.alpha = 1.0
                progressbar.setProgress(Float(self.webview.estimatedProgress), animated: true)
            }
        case "title": // triggers every time a page (after the first one) loads
            print("pageloaded")
            NotificationCenter.default.post(name: Notification.Name("pageLoaded"), object: nil)
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
