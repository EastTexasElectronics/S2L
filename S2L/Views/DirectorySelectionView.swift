import SwiftUI

/// A view for selecting a directory with a text field and a browse button
struct DirectorySelectionView: View {
    /// The title to display above the directory selection controls.
    let title: String
    /// The binding to the directory string.
    @Binding var directory: String
    /// The action to perform when the browse button is tapped.
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            HStack {
                TextField("Directory", text: $directory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 200)
                Button(action: action) {
                    Text("Browse")
                }
                .help("Select \(title.lowercased())")
            }
        }
        .padding()
    }
}

/// SwiftUI preview for DirectorySelectionView.
struct DirectorySelectionView_Previews: PreviewProvider {
    @State static var directory = ""

    static var previews: some View {
        DirectorySelectionView(title: "Select Directory", directory: $directory, action: {
        })
    }
}
