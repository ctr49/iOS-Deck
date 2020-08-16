// Created for iOS Deck in 2020
// Using Swift 5.0

import UIKit
import SwiftUI

struct RefreshScrollView: UIViewRepresentable {
    var size: CGSize
    
    let viewModel = BoardsViewModel()
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .valueChanged)
        
        let refreshVC = UIHostingController(rootView: BoardsListView(viewModel: viewModel))
        refreshVC.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        scrollView.addSubview(refreshVC.view)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        var refreshScrollView: RefreshScrollView
        var viewModel: BoardsViewModel
        
        init(_ refreshScrollView: RefreshScrollView, viewModel: BoardsViewModel) {
            self.refreshScrollView = refreshScrollView
            self.viewModel = viewModel
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            viewModel.updateBoards()
            sender.endRefreshing()
        }
    }
}
