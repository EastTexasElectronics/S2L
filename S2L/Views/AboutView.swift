import SwiftUI

/// A view that provides information about the app, including the app version and links to relevant resources.
struct AboutView: View {
    /// Binding to control the presentation of the AboutView.
    @Binding var isPresented: Bool
    /// The latest version of the app available on the App Store.
    var latestVersion: String? = nil  // Set to nil to indicate that an update is not available
    /// The URL of the app on the App Store.
    private let appStoreURL = "https://apps.apple.com/app/idYOUR_APP_ID"  // Replace with your actual App Store URL

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("About This App")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Update message
                    if latestVersion != nil {
                        Text("An update is available. Please visit the App Store to download the latest version.")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    // App version
                    AboutSection(title: "App Version:", description: "1.0.0")
                    
                    // Latest version
                    if let latestVersion = latestVersion {
                        AboutSection(title: "Latest Version:", description: latestVersion)
                    }

                    // GitHub link
                    AboutSection(title: "GitHub:", description: "Visit our GitHub repository for more information.", link: "https://github.com/EastTexasElectronics/s2l")
                    
                    // Contact email link
                    AboutSection(title: "Contact:", description: "Contact us at Contact@EastTexasElectronics.com", link: "mailto:Contact@EastTexasElectronics.com")
                }
                .padding()
            }

            HStack {
                // Store button
                Button(action: {
                    if let url = URL(string: appStoreURL) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text(latestVersion != nil ? "Update Now" : "Leave a Review")
                        .padding(.horizontal)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .accessibilityLabel(latestVersion != nil ? "Update to the latest version" : "Leave a review on the App Store")
                }
                .buttonStyle(DefaultButtonStyle())
                .padding()

                Spacer()
                
                // Close button
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

/// A view representing a section of the about information, including a title and description, with an optional link.
struct AboutSection: View {
    /// The title of the about section.
    let title: String
    /// The description of the about section.
    let description: String
    /// An optional link for the about section.
    let link: String?

    /// Initializes a new instance of `AboutSection`.
    /// - Parameters:
    ///   - title: The title of the section.
    ///   - description: The description of the section.
    ///   - link: An optional link associated with the section.
    init(title: String, description: String, link: String? = nil) {
        self.title = title
        self.description = description
        self.link = link
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Section title
            Text(title)
                .fontWeight(.semibold)
            // Description with optional link
            if let link = link, let url = URL(string: link) {
                Link(description, destination: url)
                    .foregroundColor(.blue)
                    .accessibilityHint("Opens in your default browser")
            } else {
                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// A preview provider for the AboutView.
struct AboutView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        AboutView(isPresented: $isPresented, latestVersion: "1.0.1")
        AboutView(isPresented: $isPresented, latestVersion: nil)
    }
}
