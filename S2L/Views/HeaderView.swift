import SwiftUI

struct HeaderView: View {
    @Binding var modals: Modals

    var body: some View {
        HStack {
            Spacer()
            Image("s2l")
                .resizable()
                .frame(width: 500, height: 100)
                .aspectRatio(contentMode: .fit)
                .padding()
                .accessibilityLabel("S2L Banner Logo")
            Spacer()
            HeaderButton(iconName: "questionmark.circle", action: {
                modals.showingHelpModal = true
            })
            HeaderButton(iconName: "info.circle", action: {
                modals.showingAboutModal = true
            })
        }
    }
}
