// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct DescriptionPreview: View {
    @Binding var card: NCCommunicationDeckCards
    @Binding var showingDescription: Bool
    @Binding var editingDescription: Bool
    @ObservedObject var viewModel: StacksViewModel
    
    @State private var hideDescriptionPreview: Bool = false
    
    private let limit = 250
    
    var body: some View {
        let (stackIndex, cardIndex) = viewModel.getCardIndexesByID(card.id)!
        
        VStack(alignment: .leading) {
            HStack {
                if (viewModel.stacks[stackIndex].cards![cardIndex].desc == "") {
                    Text("Tap to add description...")
                        .foregroundColor(Color.gray)
                        .font(.body)
                } else {
                    // this is dumb but wrapping this thing in a bool check makes it rerender correctly when coming back from the full screen cover
                    (hideDescriptionPreview) ? PreviewDescriptionText : PreviewDescriptionText
                }
                Spacer()
            }
            Spacer()
        }
        .frame(maxHeight: 200)
        .padding(.horizontal, 5)
        .padding(.bottom, 5)
        .padding(.top, 8)
        .fullScreenCover(isPresented: $showingDescription) {
            // onDismiss
            showingDescription = false
            hideDescriptionPreview = false
        } content: {
            DescriptionScreen
                .onAppear() {
                    hideDescriptionPreview = true
                }
        }
        .onTapGesture {
            showingDescription = true
        }
    }
    
    private var DescriptionScreen: some View {
        return NavigationView {
            Group {
                if (editingDescription) {
                    EditDescriptionView
                } else {
                    ViewDescriptionView
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarColor(.secondarySystemBackground)
            .navigationBarItems(leading: Button() {
                self.showingDescription = false
            } label: {
                Text("Back")
            }, trailing: editButton)
        }
    }
    
    private var PreviewDescriptionText: some View {
        let (stackIndex, cardIndex) = viewModel.getCardIndexesByID(card.id)!
        
        let list = viewModel.stacks[stackIndex].cards![cardIndex].getDescriptionLines()
        var limitedList: [DescriptionLine] = []
        for line in list {
            if (line.index >= 7) {
                limitedList.append(DescriptionLine(index: line.index, lineText: "...", checkListItem: nil))
                break
            }
            limitedList.append(line)
        }
        return VStack {
            ForEach(limitedList, id: \.self) {
                item in
                DescriptionLineView(card: viewModel.stacks[stackIndex].cards![cardIndex], item: item, viewModel: viewModel, toggleAble: false)
            }
        }
    }
    
    private var EditDescriptionView: some View {
        let (stackIndex, cardIndex) = viewModel.getCardIndexesByID(card.id)!
        let binding = Binding<String>(get: {
            viewModel.stacks[stackIndex].cards![cardIndex].desc
        }, set: {
            if ($0.count <= limit) {
                viewModel.stacks[stackIndex].cards![cardIndex].desc = $0
            }
        })
        
        return TextEditor(text: binding)
            .font(.body)
            .zIndex(1)
    }
    
    private var ViewDescriptionView: some View {
        let (stackIndex, cardIndex) = viewModel.getCardIndexesByID(card.id)!
        
        return ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.stacks[stackIndex].cards![cardIndex].getDescriptionLines(), id: \.self) {
                    item in
                    DescriptionLineView(card: viewModel.stacks[stackIndex].cards![cardIndex], item: item, viewModel: viewModel, toggleAble: true)
                }
            }
            .padding(15)
        }
    }
    
    private var editButton: some View {
        Button() {
            self.editingDescription.toggle()
        } label: {
            if (editingDescription) {
                Text("Save")
                    .foregroundColor(Color.blue)
            } else {
                Text("Edit")
            }
        }
    }
}

struct DescriptionLineView: View {
    @State var card: NCCommunicationDeckCards
    @State var item: DescriptionLine
    @ObservedObject var viewModel: StacksViewModel
    @State var toggleAble: Bool
    
    var body: some View {
        if (item.checkListItem != nil) {
            HStack {
                Button(action: (toggleAble) ? checkListItemTapped : {}) {
                    HStack {
                        Text(item.checkListItem!.leadingSpaces)
                        Image(systemName: item.checkListItem!.checked ? "checkmark.square" : "square")
                        Text(item.checkListItem!.text)
                    }
                    .font(.title3)
                }
                Spacer()
            }
        } else {
            HStack {
                Text(item.lineText)
                Spacer()
            }
        }
    }
    
    private func checkListItemTapped() {
        item.checkListItem!.checked.toggle()
        viewModel.updateDescriptionCheckbox(stackID: card.stackId, cardID: card.id, item.checkListItem!.checked, range: item.checkListItem!.checkBoxRange)
    }
}


extension NCCommunicationDeckCards {
    func getDescriptionLines() -> [DescriptionLine] {
        var items: [DescriptionLine] = []
        
        let lines = self.desc.split(whereSeparator: \.isNewline)
        lines.enumerated().forEach({
            (index, line) in
            var descriptionLine = DescriptionLine(index: index, lineText: line, checkListItem: nil)
            if let checkListItem = getCheckBoxFromLine(line) {
                descriptionLine.checkListItem = checkListItem
            }
            items.append(descriptionLine)
        })
        
        return items
    }
    
    private func getCheckBoxFromLine(_ line: Substring) -> CheckListItem? {
        let findGroups = String(line).findGroups(for:"( +)?- \\[(x|\\ )\\] (.+)")
        if (!findGroups.isEmpty) {
            let groups = findGroups.first!
            let checkBoxRange = line.range(of: "- \\[(x|\\ )\\]", options: .regularExpression)
            return CheckListItem(checked: groups[2] == "x", text: String(groups[3]), leadingSpaces: String(groups[1]), checkBoxRange: checkBoxRange!)
        }
        return nil
    }
}

struct CheckListItem: Hashable {
    var checked: Bool
    var text: String
    var leadingSpaces: String
    var checkBoxRange: Range<String.Index>
}

struct DescriptionLine: Hashable {
    var index: Int
    var lineText: Substring
    var checkListItem: CheckListItem?
}

extension String {
    func findGroups(for regexPattern: String) -> [[Substring]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return text[range]
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
