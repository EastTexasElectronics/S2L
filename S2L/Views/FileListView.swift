import SwiftUI

struct FilesListView: View {
    @Binding var files: [File]
    var removeFile: (File) -> Void

    var body: some View {
        List {
            ForEach($files) { $file in
                FileRow(file: $file, removeAction: { removeFile(file) })
            }
        }
        .frame(maxHeight: .infinity)
        .accessibilityIdentifier("List of all files.")
    }
}
