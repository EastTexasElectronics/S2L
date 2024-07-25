import SwiftUI

/// A view to display feedback messages to the user.
struct FeedbackView: View {
    /// Binding to control the presentation state of the view.
    @Binding var isPresented: Bool
    /// The feedback message to display.
    var message: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Warning:")
                .font(.headline)  // Display the headline.
            Text(message)
                .padding()  // Display the feedback message with padding.
                .multilineTextAlignment(.center)  // Center the text
            HStack(spacing: 20) {
                Button(action: {
                    isPresented = false  // Close the view when the button is tapped.
                }) {
                    Text("Close")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(10)
                }
                Button(action: {
                    if let url = URL(string: "https://github.com/EastTexasElectronics/Svg2LiquidDemo/issues") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Report Issue")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(10)
                }
            }
        }
        .padding()  // Add padding around the VStack.
    }
}

/// SwiftUI preview for FeedbackView.
struct FeedbackView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        Group {
            FeedbackView(isPresented: $isPresented, message: "Please select files to edit.")
            FeedbackView(isPresented: $isPresented, message: "Error reading directory contents.")
            FeedbackView(isPresented: $isPresented, message: "File does not exist at path.")
            FeedbackView(isPresented: $isPresented, message: "Error converting file.")
        }
    }
}
