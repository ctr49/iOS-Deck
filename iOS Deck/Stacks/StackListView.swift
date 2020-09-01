// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication
import MobileCoreServices

struct StackListView: UIViewRepresentable {
    @State var stack: NCCommunicationDeckStacks
    @ObservedObject var viewModel: StacksViewModel
    @State var permissionToEdit: Bool
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        if (viewModel.getStackByID(stack.id).cards?.count ?? 0 == 0) {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "This stack is empty."
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dragDelegate = context.coordinator
        tableView.dropDelegate = context.coordinator
        
        tableView.dragInteractionEnabled = permissionToEdit

        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
        tableView.layoutIfNeeded()
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.beginUpdates()
        uiView.layoutIfNeeded()
        
        // check for changes to the card relavant to the listcarditemview to possibly refresh that row
        let oldCards = context.coordinator.stack.cards
        let newCards = viewModel.getStackByID(stack.id).cards
        var reloadRows: [IndexPath] = []
        newCards?.enumerated().forEach() {
            index, newCard in
            if let oldCard = oldCards?.firstIndex(where: { $0.id == newCard.id }) {
                ///todo check for label changes or title changes and reload row appropriately
                if (newCard.desc != oldCards![oldCard].desc) {
                    reloadRows.append(IndexPath(row: index, section: 0))
                }
            }
        }
        uiView.reloadRows(at: reloadRows, with: .automatic)
        // keep whole stack up to date with new data
        context.coordinator.stack.cards = viewModel.getStackByID(stack.id).cards?.map({ $0.copy() }) as? [NCCommunicationDeckCards]
        
        uiView.dragInteractionEnabled = permissionToEdit
        
        if (viewModel.getStackByID(stack.id).cards?.count ?? 0 == 0) {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "This stack is empty."
            uiView.backgroundView = label
        } else {
            uiView.backgroundView = nil
        }
        
        uiView.endUpdates()
    }
    
    func makeCoordinator() -> StackCoordinator {
        var stackSorted = stack
        stackSorted.cards = stackSorted.cards?.sorted(by: { $0.order < $1.order })
        return StackCoordinator(stack: stackSorted, viewModel: viewModel)
    }
}

class HostingCell: UITableViewCell {
    var host: UIHostingController<AnyView>?
}

class StackCoordinator: NSObject {
    var stack: NCCommunicationDeckStacks
    var viewModel: StacksViewModel
    
    init(stack: NCCommunicationDeckStacks, viewModel: StacksViewModel) {
        self.stack = stack
        self.viewModel = viewModel
    }
}

extension StackCoordinator: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.getStackByID(self.stack.id).cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostingCell
        
        let view = CardListItemView(card: viewModel.getStackByID(stack.id).cards![indexPath.row])
        
        // create & setup hosting controller only once
        if tableViewCell.host == nil {
            let controller = UIHostingController(rootView: AnyView(view))
            tableViewCell.host = controller
            
            let tableCellViewContent = controller.view!
            tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
            
            // make all backgrounds around the CardView clear
            tableCellViewContent.backgroundColor = .clear
            tableViewCell.backgroundColor = .clear
            
            // get rid of any possible background selection messing up the view
            tableView.allowsSelection = false
            tableView.allowsMultipleSelection = false
            tableViewCell.selectionStyle = .none
            
            tableViewCell.contentView.addSubview(tableCellViewContent)
            tableCellViewContent.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor).isActive = true
            tableCellViewContent.leftAnchor.constraint(equalTo: tableViewCell.contentView.leftAnchor).isActive = true
            tableCellViewContent.bottomAnchor.constraint(equalTo: tableViewCell.contentView.bottomAnchor).isActive = true
            tableCellViewContent.rightAnchor.constraint(equalTo: tableViewCell.contentView.rightAnchor).isActive = true
        } else {
            // reused cell, so just set other SwiftUI root view
            tableViewCell.host?.rootView = AnyView(view)
        }
        tableViewCell.setNeedsLayout()
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StackCoordinator: UITableViewDragDelegate {
    // Provides the initial set of items (if any) to drag.
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let card = viewModel.getStackByID(stack.id).cards?[indexPath.row] else {
            return []
        }
        
        let itemProvider = NSItemProvider(object: card)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = card
        // pass context along for moving cards between
        session.localContext = (stack, indexPath, tableView)
        return [dragItem]
    }
    
    // make sure the background color of the cell stays clear when its being dragged
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            let param = UIDragPreviewParameters()
            param.backgroundColor = .clear
            return param
    }
}

extension StackCoordinator: UITableViewDropDelegate, UIDropInteractionDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypeData as String]) {
            coordinator.session.loadObjects(ofClass: NCCommunicationDeckCards.self) {
                (cards) in
                guard let card = cards.first as? NCCommunicationDeckCards else {
                    return
                }
                
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    // Same Table View
                    let updatedIndexPaths: [IndexPath]
                    if sourceIndexPath.row < destinationIndexPath.row {
                        updatedIndexPaths =  (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
                    } else if sourceIndexPath.row > destinationIndexPath.row {
                        updatedIndexPaths =  (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: 0) }
                    } else {
                        updatedIndexPaths = []
                    }
                    tableView.beginUpdates()
                    self.viewModel.moveCardInStack(card, sourceIndex: sourceIndexPath.row, destIndex: destinationIndexPath.row)
                    tableView.reloadRows(at: updatedIndexPaths, with: .automatic)
                    tableView.endUpdates()
                    break
                    
                case (nil, .some(let destinationIndexPath)):
                    // Move data from a table to another table
                    
                    self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
                    tableView.beginUpdates()
                    self.viewModel.insertCardIntoStack(card, stackID: self.stack.id, destIndex: destinationIndexPath.row)
                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    tableView.endUpdates()
                    break
                case (nil, nil):
                    // Insert data from a table to another table
                    // when dragging things onto the bottom
                    self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
                    tableView.beginUpdates()
                    self.viewModel.insertCardIntoStack(card, stackID: self.stack.id, destIndex: nil)
                    tableView.insertRows(at: [IndexPath(row: self.viewModel.getStackByID(self.stack.id).cards!.count - 1, section: 0)], with: .automatic)
                    tableView.endUpdates()
                    break
                default: break
                }
            }
        }
    }
    
    func removeSourceTableData(localContext: Any?) {
        if let (dataSource, sourceIndexPath, tableView) = localContext as? (NCCommunicationDeckStacks, IndexPath, UITableView) {
            tableView.beginUpdates()
            viewModel.removeCardFromStack(dataSource.id, sourceIndexPath.row)
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
}
