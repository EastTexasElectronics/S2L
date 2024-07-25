import SwiftUI

/// Model for storing bulk edit settings.
struct BulkEditSettings {
    var viewport: [String] = ["", "", "", ""]
    var className: String = ""
    var fill: String = ""
    var prefix: String = ""
}

/// View for performing bulk edits on files.
struct BulkEditView: View {
    /// Binding to control the presentation state of the view.
    @Binding var isPresented: Bool
    /// Binding to the bulk edit settings.
    @Binding var settings: BulkEditSettings
    /// Binding to the list of files.
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
                // Container for viewBox settings
                viewportSection
                // Container for other settings
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

    /// View for the viewport section of the form.
    private var viewportSection: some View {
        HStack(spacing: 10) {
            viewBoxField(label: "X", text: $settings.viewport[0])
            viewBoxField(label: "Y", text: $settings.viewport[1])
            viewBoxField(label: "W", text: $settings.viewport[2])
            viewBoxField(label: "H", text: $settings.viewport[3])
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 20)
    }

    /// View for the settings section of the form.
    private var settingsSection: some View {
        VStack(spacing: 20) {
            textFieldSection(title: "Class:", text: $settings.className)
            textFieldSection(title: "Fill:", text: $settings.fill)
            textFieldSection(title: "Prefix:", text: $settings.prefix)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    /**
     Creates a view for a single viewBox field.
     
     - Parameters:
       - label: The label for the field.
       - text: The binding to the text for the field.
     - Returns: A view representing the viewBox field.
     */
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

    /**
     Creates a view for a single text field section.
     
     - Parameters:
       - title: The title for the section.
       - text: The binding to the text for the field.
     - Returns: A view representing the text field section.
     */
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

    /**
     Applies the bulk edit settings to the selected files.
     
     - Throws: An error if the bulk edit fails.
     */
    private func applyBulkEdit() throws {
        for index in files.indices where files[index].isSelected {
            if !settings.viewport.allSatisfy({ $0.isEmpty }) {
                files[index].viewport = settings.viewport
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

/// SwiftUI preview for BulkEditView.
struct BulkEditView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var settings = BulkEditSettings()
    @State static var files = [File(name: "File1", viewport: ["0", "0", "24", "24"], className: "icon", fill: "#000", prefix: "icon-", isSelected: true)]

    static var previews: some View {
        BulkEditView(isPresented: $isPresented, settings: $settings, files: $files)
    }
}
