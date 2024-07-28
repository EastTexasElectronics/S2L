import SwiftUI

// Model for storing bulk edit settings
struct BulkEditSettings {
    var viewBox: [String] = ["", "", "", ""]
    var className: String = ""
    var fill: String = ""
    var prefix: String = ""
}

// View for performing bulk edits on files.
struct BulkEditView: View {
    @Binding var isPresented: Bool
    @Binding var settings: BulkEditSettings
    @Binding var files: [File]

    var body: some View {
        VStack {
            Text("Bulk Edit")
                .font(.title)
                .padding(.bottom)

            Text("Click Apply to add these settings to the selected files")
                .font(.subheadline)
                .padding(.bottom)

            VStack {
                viewBoxSection
                settingsSection
            }

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Button("Apply") {
                    do {
                        try applyBulkEdit()
                        isPresented = false
                    } catch {
                        print("Error applying bulk edit: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
        }
        .padding()
        .frame(width: 320, height: 320)
    }

    // View for the viewBox section of the form.
    private var viewBoxSection: some View {
        HStack(spacing: 10) {
            viewBoxField(label: "X", text: $settings.viewBox[0])
            viewBoxField(label: "Y", text: $settings.viewBox[1])
            viewBoxField(label: "W", text: $settings.viewBox[2])
            viewBoxField(label: "H", text: $settings.viewBox[3])
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 20)
    }

    // View for the settings section of the form.
    private var settingsSection: some View {
        VStack(spacing: 20) {
            textFieldSection(title: "Class:", text: $settings.className)
            textFieldSection(title: "Fill:", text: $settings.fill)
            textFieldSection(title: "Prefix:", text: $settings.prefix)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // Creates a view for a single viewBox field.
    private func viewBoxField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Image(systemName: "info.circle")
            }
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
        }
    }

    // Creates a view for a single text field section.
    private func textFieldSection(title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .frame(width: 50, alignment: .leading)
            Image(systemName: "info.circle")
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
        }
    }

    // Applies the bulk edit settings to the selected files.

    private func applyBulkEdit() throws {
        for index in files.indices where files[index].isSelected {
            if !settings.viewBox.allSatisfy({ $0.isEmpty }) {
                files[index].viewBox = settings.viewBox
            }
            if !settings.className.isEmpty {
                files[index].className = settings.className
            }
            if !settings.fill.isEmpty {
                files[index].fill = settings.fill
            }
            if !settings.prefix.isEmpty {
                files[index].prefix = settings.prefix
            }
        }
    }
}

// Preview for BulkEditView.
struct BulkEditView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var settings = BulkEditSettings()
    @State static var files = [File(name: "File1", viewBox: ["0", "0", "24", "24"], className: "icon", fill: "#000", prefix: "icon-", isSelected: true)]

    static var previews: some View {
        BulkEditView(isPresented: $isPresented, settings: $settings, files: $files)
    }
}
