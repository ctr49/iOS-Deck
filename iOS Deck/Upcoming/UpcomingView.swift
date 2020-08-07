// Created for ios-deck in 2020
// Using Swift 5.0

import SwiftUI

struct UpcommingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Due View")
            }
            .navigationBarTitle("Due", displayMode: .automatic)
        }
    }
}

struct UpcommingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcommingView()
    }
}
