import SwiftUI
// asd
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
