import SwiftUI

@main
struct S2LApp: App {
    @State private var showingAboutView = false
    @State private var showingHelpView = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $showingAboutView) {
                    AboutView(isPresented: $showingAboutView)
                }
                .sheet(isPresented: $showingHelpView) {
                    HelpView(isPresented: $showingHelpView)
                }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About S2L") {
                    showingAboutView = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            
            CommandGroup(replacing: .help) {
                Button("S2L Help") {
                    showingHelpView = true
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    }
}
