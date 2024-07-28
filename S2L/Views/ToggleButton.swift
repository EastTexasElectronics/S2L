import SwiftUI

// Checkbox to select a file for bulk edit or removal
struct ToggleButton: View {
    @Binding var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "checkmark.square" : "square")
        }
        .help(isSelected ? "Deselect All Files" : "Select All Files")
        .padding(.trailing, 8)
    }
}
