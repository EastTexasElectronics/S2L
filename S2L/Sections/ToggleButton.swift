import SwiftUI
//asd
struct ToggleButton: View {
    @Binding var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "checkmark.square" : "square")
        }
        .help(isSelected ? "Deselect all files" : "Select all files")
        .padding(.trailing, 8)
    }
}
