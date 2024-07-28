import SwiftUI

struct ProgressView: View {
    @Binding var isPresented: Bool
    @Binding var logMessages: String
    let startTime: Date
    let destinationDirectory: String
    @Binding var filesConverted: Int
//    TODO: Make this window 800x600 size upon opening and open in center of screen.
//    TODO: Make progress scrollable area automatily move down as content it added

    var body: some View {
        VStack {
            Text("Conversion Progress")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                Text(logMessages)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(Color.green)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding()
            }
            
            Button("Close") {
                isPresented = false
            }
            .padding()
        }
        .onAppear {
            if filesConverted > 0 {
                let timeTaken = Date().timeIntervalSince(startTime)
                logMessages += "\nFile conversions complete.\n"
                logMessages += "Number of Files Converted: \(filesConverted)\n"
                logMessages += "Time Taken: \(String(format: "%.2f", timeTaken)) seconds\n"
                logMessages += "Destination Directory: \(destinationDirectory)"
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(isPresented: .constant(true), logMessages: .constant("Sample Log Messages"), startTime: Date(), destinationDirectory: "/path/to/destination", filesConverted: .constant(10))
    }
}
