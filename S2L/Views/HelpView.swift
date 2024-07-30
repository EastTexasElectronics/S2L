import SwiftUI

// Help menu view, displays the help menu
struct HelpView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("How to Use the SVG to Liquid Converter")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Group {
                            HelpSection(title: "1. Adding SVG Files:", description: "Click 'Browse' next to 'Add Your SVG's' to select SVG files or a directory containing SVG files.")
                            HelpSection(title: "2. Setting Output Directory:", description: "Click 'Browse' next to 'Select Output' to choose where the converted files will be saved.")
                            HelpSection(title: "3. Customizing Conversion:", description: """
                                For each SVG file, you can customize:
                                • viewBox: Set X, Y, Width, and Height
                                • Class: Add a CSS class to the SVG
                                • Fill: Specify a fill color
                                • Prefix: Add a prefix to the file name (max 5 characters)
                                """)
                            HelpSection(title: "4. Converting Files:", description: "Click the 'Convert' button to start the conversion process.")
                            HelpSection(title: "5. Clearing Files:", description: "Use the 'Clear All' button to remove all files from the list.")
                            HelpSection(title: "6. Bulk Editing:", description: "Select multiple files using checkboxes, then click 'Bulk Edit' to modify them all at once.")
                        }
                    }
                    .padding()
                }
                
                // Buttons at the bottom
                HStack {
                    Button(action: {
                        if let url = URL(string: "https://www.roberthavelaar.dev/S2L") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Text("Support Website")
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .padding()
                    .accessibilityIdentifier("Link to S2L Homepage")

                    Spacer()
                    
                    Button(action: {
                        // Open email client to send support email
                        let email = "Contact@EastTexasElectronics.com"
                        if let url = URL(string: "mailto:\(email)") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Support")
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .padding()
                    .accessibilityIdentifier("SupportButton")
                    
                    Spacer()
                    
                    Button("Close") {
                        isPresented = false
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .padding()
                    .accessibilityIdentifier("CloseButton")
                }
                .padding(.horizontal)
            }
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
    
    // Opens a URL using the default system browser.
    private func openURL(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
}

// Help section with a title and description.
struct HelpSection: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .fontWeight(.semibold)
            Text(description)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// A preview for the HelpView.
struct HelpView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        HelpView(isPresented: $isPresented)
    }
}
