import SwiftUI

// A view that provides information about the app
struct AboutView: View {
    @Binding var isPresented: Bool
    var latestVersion: String? = nil
    private let appStoreURL = "https://apps.apple.com/app/idYOUR_APP_ID"

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
// TODO: UPDATE LINK
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


struct AboutSection: View {
    let title: String
    let description: String
    let link: String?

    /* Initializes a new instance of `AboutSection`.
     - Parameters:
          - title: The title of the section.
          - description: The description of the section.
          - link: An optional link associated with the section. */
    init(title: String, description: String, link: String? = nil) {
        self.title = title
        self.description = description
        self.link = link
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .fontWeight(.semibold)
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

// Preview provider for the AboutView.
struct AboutView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        AboutView(isPresented: $isPresented, latestVersion: "1.0.1")
        AboutView(isPresented: $isPresented, latestVersion: nil)
    }
}
