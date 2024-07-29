import SwiftUI

struct ContentView: View {
    @StateObject private var manager = FileConversionManager()
    @State private var bulkEditSettings = BulkEditSettings()
    @State private var selectAll = false
    @State private var isUpdateAvailable = false
    @State private var latestVersion: String?
    @State private var resultMessage: String?

    var body: some View {
        VStack {
            HeaderView(modals: $manager.modals)
            HStack {
                DirectorySelectionView(title: "Add Your SVG's:", directory: $manager.directories.inputDirectory) {
                    manager.browseInputDirectory()
                }
                DirectorySelectionView(title: "Output Location:", directory: $manager.directories.outputDirectory) {
                    manager.browseOutputDirectory()
                }
            }
            .padding()
            FilesHeaderView(selectAll: $selectAll, toggleSelectAll: toggleSelectAll)
            FilesListView(files: $manager.files, removeFile: removeFile)
            ActionButtonsView(files: $manager.files, modals: $manager.modals, feedbackMessage: $manager.feedbackMessage, isFeedbackViewPresented: $manager.isFeedbackViewPresented, clearSelectedFiles: manager.clearSelectedFiles, startConversion: manager.startConversion)
        }
        .padding()
        .sheet(isPresented: $manager.modals.showingHelpModal) {
            HelpView(isPresented: $manager.modals.showingHelpModal)
        }
        .sheet(isPresented: $manager.modals.showingBulkEditModal) {
            BulkEditView(isPresented: $manager.modals.showingBulkEditModal, settings: $bulkEditSettings, files: $manager.files)
        }
        .sheet(isPresented: $manager.modals.showingAboutModal) {
            AboutView(isPresented: $manager.modals.showingAboutModal, latestVersion: latestVersion)
        }
        .sheet(isPresented: $manager.isProgressViewPresented) {
            ProgressView(isPresented: $manager.isProgressViewPresented, logMessages: $manager.logMessages, startTime: manager.startTime, destinationDirectory: manager.directories.outputDirectory, filesConverted: $manager.filesConverted)
        }
        .sheet(isPresented: $manager.isFeedbackViewPresented) {
            FeedbackView(isPresented: $manager.isFeedbackViewPresented, message: manager.feedbackMessage)
        }
        .onAppear {
            checkForUpdate()
        }
    }

    private func toggleSelectAll() {
        selectAll.toggle()
        manager.files.indices.forEach { manager.files[$0].isSelected = selectAll }
    }

    private func removeFile(file: File) {
        if let index = manager.files.firstIndex(where: { $0.id == file.id }) {
            manager.files.remove(at: index)
        }
    }

    private func checkForUpdate() {
        fetchAppStoreVersion { appStoreVersion in
            guard let appStoreVersion = appStoreVersion else { return }

            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                DispatchQueue.main.async {
                    latestVersion = appStoreVersion
                    isUpdateAvailable = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
