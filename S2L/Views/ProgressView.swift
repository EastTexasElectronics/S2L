import SwiftUI

// A view that displays the progress of file conversions with a log of messages
struct ProgressView: View {
    @Binding var isPresented: Bool
    @Binding var logMessages: String
    let startTime: Date
    let destinationDirectory: String
    @Binding var filesConverted: Int

    var body: some View {
        VStack {
            Text("SVG 2 Liquid Terminal")
                .font(.largeTitle)
                .padding()
                .accessibility(label: Text("Information on this view displays success or failure messages. If an error has occurred you will also see it after closing this window."))
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(formattedLogMessages, id: \.self) { message in
                            Text(message)
                                .foregroundColor(colorForMessage(message))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .accessibility(label: Text(message))
                        }
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding()
                    .id("logText")
                }
                .onChange(of: logMessages) { _ in
                    withAnimation {
                        proxy.scrollTo("logText", anchor: .bottom)
                    }
                }
            }
            
            Button("Close") {
                isPresented = false
            }
            .padding()
        }
        .frame(width: 800, height: 600)
        .onAppear {
            // Center the window when the view appears
            if let window = NSApplication.shared.windows.last {
                window.center()
            }
            // Add summary of conversions to the log if there are converted files
            if filesConverted > 0 {
                let timeTaken = Date().timeIntervalSince(startTime)
                logMessages += "\n\nFile conversions complete.\n"
                logMessages += "Number of Files Converted: \(filesConverted)\n"
                logMessages += "Time Taken: \(String(format: "%.2f", timeTaken)) seconds\n"
                logMessages += "Destination Directory: \(destinationDirectory)"
            }
        }
    }

    // Formats log messages by prepending "-> " to each line
    private var formattedLogMessages: [String] {
        logMessages.split(separator: "\n").map { "-> \($0)" }
    }

    // Determines the color for a log message based on its content
    private func colorForMessage(_ message: String) -> Color {
        if message.contains("Error:") {
            return .red
        } else if message.contains("Successfully converted file") {
            return .gray
        } else {
            return .green
        }
    }
}

// Preview for ProgressView.
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(isPresented: .constant(true), logMessages: .constant("Error:"), startTime: Date(), destinationDirectory: "/path/to/destination", filesConverted: .constant(10))
    }
}
