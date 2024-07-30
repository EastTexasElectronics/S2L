import SwiftUI

// A view to display error messages to the user.
struct FeedbackView: View {
    @Binding var isPresented: Bool
    var message: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Error:")
                .font(.headline)
                .accessibility(label: Text("Error:"))

            Text(message)
                .padding()
                .multilineTextAlignment(.center)
                .accessibility(label: Text(message))

            HStack(spacing: 20) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Close")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(10)
                }
                .accessibility(label: Text("Close button"))
                Button(action: {
                    if let url = URL(string: "https://www.roberthavelaar.dev/S2L") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Report Issue")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(10)
                }
                .accessibility(label: Text("Report Issue button"))
            }
        }
        .padding()
    }
}

// Preview for FeedbackView.
struct FeedbackView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        Group {
            FeedbackView(isPresented: $isPresented, message: "Error: Please select files to edit.")
            FeedbackView(isPresented: $isPresented, message: "Error: Can not read directory contents.")
            FeedbackView(isPresented: $isPresented, message: "Error: File does not exist at path.")
            FeedbackView(isPresented: $isPresented, message: "Error: Converting file(s).")
        }
    }
}
