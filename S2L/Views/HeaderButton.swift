import SwiftUI

/* A custom help button view with an icon.
    This button triggers a specified action when tapped. */
struct HeaderButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
        }
        .help("Open \(iconName)")
        .accessibilityIdentifier("\(iconName)Button")
    }
}

