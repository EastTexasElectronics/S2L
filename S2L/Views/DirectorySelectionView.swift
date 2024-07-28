import SwiftUI

// A view for selecting a directory with a text field and a browse button.
struct DirectorySelectionView: View {
    let title: String
    @Binding var directory: String
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

// Preview for DirectorySelectionView.
struct DirectorySelectionView_Previews: PreviewProvider {
    @State static var directory = ""

    static var previews: some View {
        DirectorySelectionView(title: "Select Directory", directory: $directory, action: {
        })
    }
}
