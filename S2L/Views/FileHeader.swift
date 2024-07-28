import SwiftUI

/* A view representing a file header with a title and an info icon.
    The info icon displays a help message when hovered over. */
struct FileHeader: View {
    let title: String
    let info: String
    let minWidth: CGFloat

    var body: some View {
        HStack(spacing: 4) {
            Text(title + ":")
            Image(systemName: "info.circle")
                .help(info)
        }
        .frame(minWidth: minWidth, alignment: .leading)
    }
}

// A preview for the FileHeaderView.
struct FileHeader_Previews: PreviewProvider {
    static var previews: some View {
        FileHeader(title: "Example", info: "This is an example info message.", minWidth: 100)
    }
}
