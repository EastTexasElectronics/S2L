import SwiftUI

/// A view representing a single row for a file with various editable attributes
struct FileRow: View {
    /// The binding to the file model.
    @Binding var file: File
    /// The action to perform when the remove button is tapped.
    var removeAction: () -> Void

    var body: some View {
        HStack {
            // Toggle for selecting the file.
            Toggle(isOn: $file.isSelected) {
                EmptyView()
            }
            .toggleStyle(CheckboxToggleStyle())
            .help("Select for bulk edit")

            // Button for removing the file.
            Button(action: {
                removeAction()
            }) {
                Image(systemName: "xmark.circle")
                    .imageScale(.small)
            }
            .help("Remove this file")

            // Display the truncated file name.
            Text(file.name)
                .lineLimit(1) // Truncate long file names
                .frame(minWidth: 100, maxWidth: 200, alignment: .leading) // Adjust as necessary
            Spacer()

            // Editable fields for viewBox attributes.
            HStack {
                TextField("x", text: Binding(
                    get: { file.viewport[0] },
                    set: { file.viewport[0] = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 30)

                TextField("y", text: Binding(
                    get: { file.viewport[1] },
                    set: { file.viewport[1] = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 30)

                TextField("width", text: Binding(
                    get: { file.viewport[2] },
                    set: { file.viewport[2] = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)

                TextField("height", text: Binding(
                    get: { file.viewport[3] },
                    set: { file.viewport[3] = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
            }
            .frame(minWidth: 140, alignment: .center)
            Spacer()

            // Editable field for className attribute.
            TextField("Class", text: $file.className)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 150)
            Spacer()

            // Editable field for fill attribute.
            TextField("Fill", text: $file.fill)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 100)
            Spacer()

            // Editable field for prefix attribute.
            TextField("Prefix", text: Binding(
                get: { file.prefix },
                set: {
                    if $0.count <= 5 {
                        file.prefix = $0
                    }
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 60)
        }
        .padding(.vertical, 2)
    }
}

/// SwiftUI preview for FileRow.
struct FileRow_Previews: PreviewProvider {
    @State static var file = File(name: "example.svg", viewport: ["0", "0", "100", "100"], className: "", fill: "", prefix: "")

    static var previews: some View {
        FileRow(file: $file, removeAction: {})
    }
}
