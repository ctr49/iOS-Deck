// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import NCCommunication

struct CardView: View {
    @State var card: NCCommunicationDeckCards
    @ObservedObject var viewModel: StacksViewModel
    
    @State private var editingTitle: Bool = false
    @State private var showingDescription: Bool = false
    @State private var editingDescription: Bool = false
    @State private var textChanged: Bool = false
    
    @State private var titleChars: Int = 0
    
    var body: some View {
        NavigationView {
            GeometryReader {
                geo in
                Form {
                    Section {
                        if (!editingTitle) {
                            Title
                                .onTapGesture {
                                    self.editingTitle = true
                                }
                        } else {
                            TitleTextArea
                        }
                        DescriptionPreview(card: $card, showingDescription: $showingDescription, editingDescription: $editingDescription, viewModel: viewModel)
                    }
                    Section {
                        NavigationLink(destination: StackPicker) {
                            HStack {
                                Label("Labels", systemImage: "tag.fill")
                                Spacer()
                                HStack {
                                    if (card.labels?.count ?? 0 > 0) {
                                        ForEach(card.labels ?? []) {
                                            label in
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .fill(Color.init(hex: "#\(label.color)"))
                                                .frame(width: 4.5)
                                        }
                                    }
                                }
                            }
                        }
                        NavigationLink(destination: StackPicker) {
                            Label("Users", systemImage: "person.2.fill")
                        }
                        NavigationLink(destination: StackPicker) {
                            Label("Activity", systemImage: "bolt.fill")
                        }
                        NavigationLink(destination: StackPicker) {
                            Label("Comments", systemImage: "text.bubble.fill")
                        }
                        NavigationLink(destination: StackPicker) {
                            Label("Attachments", systemImage: "paperclip")
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: StackPicker) {
                            Label("Move", systemImage: "square.stack.3d.down.right.fill")
                        }
                        Button() {
                            print("Delete card.")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal, -5)
                .onAppear() {
                    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
                    UITableView.appearance().alwaysBounceVertical = false
                }
            }
            .navigationBarTitle("stack/board", displayMode: .inline)
            .navigationBarColor(.systemBackground)
            //            .navigationBarItems(trailing: editButton)
        }
        .onDisappear() {
            NotificationCenter.default.post(name: .cardSelected, object: nil)
        }
        .isModalInPresentation(textChanged)
    }
    
    private var Title: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(card.title)
                    .lineLimit(4)
                    .font(.title3)
                Spacer()
            }
        }
        .padding(5)
        .padding(.top, 7)
    }
    
    private var TitleTextArea: some View {
        let limit = 100
        let binding = Binding<String>(get: {
            card.title
        }, set: {
            if ($0.count <= limit) {
                card.title = $0
                titleChars = $0.count
            }
        })
        
        return ZStack {
            TextEditor(text: binding)
                .font(.title3)
                .lineLimit(3)
                .zIndex(1)
                .onAppear() {
                    titleChars = card.title.count
                }
                .padding(.top, 4)
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill((titleChars == limit) ? Color.red : Color.green)
                        Text("\(titleChars)/\(limit)")
                            .font(.caption2)
                    }
                    .frame(width: 45, height: 15)
                    .padding(10)
                    Spacer()
                }
            }
            .zIndex(2)
        }.frame(height: 90)
    }
    
    private var StackPicker: some View {
        ScrollView {
            Text("Boobs")
        }
    }
    
    //    private var editButton: some View {
    //        Button() {
    //            self.editMode.toggle()
    //        } label: {
    //            if (editMode) {
    //                Text("Save")
    //                    .foregroundColor(Color.blue)
    //            } else {
    //                Text("Edit")
    //            }
    //        }
    //    }
    
}
