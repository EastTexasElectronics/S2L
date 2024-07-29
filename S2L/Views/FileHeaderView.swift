import SwiftUI

struct FilesHeaderView: View {
    @Binding var selectAll: Bool
    var toggleSelectAll: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            ToggleButton(isSelected: $selectAll, action: toggleSelectAll)
                .frame(width: 40)
            Text("Files")
                .frame(width: 200, alignment: .leading)
            Spacer()
            Text("viewBox")
                .frame(width: 160, alignment: .leading)
            Spacer()
            Text("Class")
                .frame(width: 150, alignment: .leading)
            Spacer()
            Text("Fill")
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text("Prefix")
                .frame(width: 100, alignment: .leading)
        }
        .padding(.horizontal)
    }
}
