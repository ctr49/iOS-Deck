// Created for iOS Deck in 2020
// Using Swift 5.0

import SwiftUI
import Introspect

extension View {
    /// A Boolean value indicating whether the view controller enforces a modal behavior.
    ///
    /// The default value of this property is `false`. When you set it to `true`, UIKit ignores events
    /// outside the view controller's bounds and prevents the interactive dismissal of the
    /// view controller while it is onscreen.
    public func isModalInPresentation(_ value: Bool) -> some View {
        introspectViewController {
            $0.isModalInPresentation = value
        }
    }
}
