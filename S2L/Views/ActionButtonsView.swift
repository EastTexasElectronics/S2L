import SwiftUI

struct ActionButtonsView: View {
    @Binding var files: [File]
    @Binding var modals: Modals
    @Binding var feedbackMessage: String
    @Binding var isFeedbackViewPresented: Bool
    var clearSelectedFiles: () -> Void
    var startConversion: () -> Void

    var body: some View {
        HStack {
            ActionButton(label: "Remove Selected", icon: "trash", action: clearSelectedFiles)
            Spacer()
            ActionButton(label: "Bulk Edit", icon: "pencil", action: {
                if files.contains(where: { $0.isSelected }) {
                    modals.showingBulkEditModal = true
                } else {
                    feedbackMessage = "Error: Please select files to edit."
                    isFeedbackViewPresented = true
                }
            })
            Spacer()
            ActionButton(label: "Convert", icon: "arrow.right.circle", action: startConversion)
        }
        .padding()
    }
}
