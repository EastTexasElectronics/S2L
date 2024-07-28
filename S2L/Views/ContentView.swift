import SwiftUI

struct ContentView: View {
    @State private var directories = Directories()
    @State private var files: [File] = []
    @State private var modals = Modals()
    @State private var bulkEditSettings = BulkEditSettings()
    @State private var selectAll = false
    @State private var isUpdateAvailable = false
    @State private var latestVersion: String?
    @State private var resultMessage: String?
    @State private var isProgressViewPresented = false
    @State private var isFeedbackViewPresented = false
    @State private var feedbackMessage = ""
    @State private var logMessages = ""
    @State private var filesConverted = 0
    @State private var startTime = Date()

    var body: some View {
        VStack {
            headerView
            directorySelectionView
            filesHeaderView
            filesListView
            actionButtons
        }
        .padding()
        .sheet(isPresented: $modals.showingHelpModal) {
            HelpView(isPresented: $modals.showingHelpModal)
        }
        .sheet(isPresented: $modals.showingBulkEditModal) {
            BulkEditView(isPresented: $modals.showingBulkEditModal, settings: $bulkEditSettings, files: $files)
        }
        .sheet(isPresented: $modals.showingAboutModal) {
            AboutView(isPresented: $modals.showingAboutModal, latestVersion: latestVersion)
        }
        .sheet(isPresented: $isProgressViewPresented) {
            ProgressView(isPresented: $isProgressViewPresented, logMessages: $logMessages, startTime: startTime, destinationDirectory: directories.outputDirectory, filesConverted: $filesConverted)
        }
        .sheet(isPresented: $isFeedbackViewPresented) {
            FeedbackView(isPresented: $isFeedbackViewPresented, message: feedbackMessage)
        }
        .onAppear {
            checkForUpdate()
        }
    }

    private var headerView: some View {
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

    private var directorySelectionView: some View {
        HStack {
            DirectorySelectionView(title: "Add Your SVG's:",
                                   directory: $directories.inputDirectory,
                                   action: browseInputDirectory)
            DirectorySelectionView(title: "Output Location:",
                                   directory: $directories.outputDirectory,
                                   action: browseOutputDirectory)
        }
        .padding()
    }

    private var filesHeaderView: some View {
        HStack(spacing: 0) {
            ToggleButton(isSelected: $selectAll, action: toggleSelectAll)
                .frame(width: 40)
            Text("Files")
                .frame(width: 200, alignment: .leading)
            Spacer()
            Text("viewBox")
                .frame(width: 160, alignment: .leading)
            Spacer()
            Text("Class")
                .frame(width: 150, alignment: .leading)
            Spacer()
            Text("Fill")
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text("Prefix")
                .frame(width: 100, alignment: .leading)
        }
        .padding(.horizontal)
    }

    private var filesListView: some View {
        List {
            ForEach($files) { $file in
                FileRow(file: $file, removeAction: { removeFile(file: file) })
            }
        }
        .frame(maxHeight: .infinity)
        .accessibilityIdentifier("List of all files.")
    }

    private var actionButtons: some View {
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

    private func browseInputDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            if let selectedDirectory = panel.url {
                directories.inputDirectory = selectedDirectory.path
                addSVGFiles(in: selectedDirectory)
            }
        }
    }

    private func browseOutputDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true

        if panel.runModal() == .OK {
            directories.outputDirectory = panel.url?.path ?? ""
        }
    }

    private func addSVGFiles(in directory: URL) {
        let fileManager = FileManager.default
        do {
            let urls = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            let svgFiles = urls.filter { $0.pathExtension.lowercased() == "svg" }
            files = svgFiles.map { url in
                File(name: url.lastPathComponent, viewBox: ["0", "0", "100", "100"], className: "", fill: "", prefix: "")
            }
        } catch {
            feedbackMessage = "Error reading directory contents: \(error.localizedDescription)"
            logMessages += "\n\nError: \(feedbackMessage)\n"
            isFeedbackViewPresented = true
        }
    }

    private func clearSelectedFiles() {
        files.removeAll { $0.isSelected }
        selectAll = false
    }

    private func startConversion() {
        logMessages = ""
        filesConverted = 0
        startTime = Date()
        isProgressViewPresented = true
        convertFiles()
    }

    private func convertFiles() {
        Task {
            await withTaskGroup(of: String?.self) { group in
                for file in files {
                    group.addTask {
                        return await processFile(file)
                    }
                }
                for await result in group {
                    if let message = result {
                        await MainActor.run {
                            logMessages += message + "\n"
                        }
                    }
                }
            }
            await MainActor.run {
                if filesConverted > 0 {
                    let timeTaken = Date().timeIntervalSince(startTime)
                    logMessages += "\n\nFile conversions complete.\n"
                    logMessages += "Number of Files Converted: \(filesConverted)\n"
                    logMessages += "Time Taken: \(String(format: "%.2f", timeTaken)) seconds\n"
                    logMessages += "Destination Directory: \(directories.outputDirectory)"
                }
            }
        }
    }

    private func processFile(_ file: File) async -> String? {
        let inputURL = URL(fileURLWithPath: directories.inputDirectory).appendingPathComponent(file.name)
        let outputDirectoryURL = directories.outputDirectory.isEmpty ? URL(fileURLWithPath: directories.inputDirectory) : URL(fileURLWithPath: directories.outputDirectory)
        var outputFileName = "\(file.prefix)\(file.name.replacingOccurrences(of: ".svg", with: ".liquid"))"
        var outputURL = outputDirectoryURL.appendingPathComponent(outputFileName)
        var counter = 1

        while FileManager.default.fileExists(atPath: outputURL.path) {
            outputFileName = "\(file.prefix)\(file.name.replacingOccurrences(of: ".svg", with: "(\(counter)).liquid"))"
            outputURL = outputDirectoryURL.appendingPathComponent(outputFileName)
            counter += 1
        }

        do {
            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                let errorMessage = "File does not exist at path: \(inputURL.path)"
                feedbackMessage = errorMessage
                logMessages += "\n\nError: \(errorMessage)\n"
                isFeedbackViewPresented = true
                return nil
            }

            var modifiedContent = try String(contentsOf: inputURL)
            modifiedContent = removeXMLTag(from: modifiedContent)
            modifiedContent = updateSVGTag(for: file, in: modifiedContent)
            modifiedContent = updatePathTags(for: file, in: modifiedContent)

            try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)
            try modifiedContent.write(to: outputURL, atomically: true, encoding: .utf8)
            await MainActor.run {
                filesConverted += 1
            }
            return "Success: Converted file \(file.name) ---> \(outputFileName)"
        } catch {
            let errorMessage = "Converting file \(file.name): \(error.localizedDescription)"
            feedbackMessage = errorMessage
            logMessages += "\n\nError: \(errorMessage)\n"
            isFeedbackViewPresented = true
            return nil
        }
    }

    private func removeXMLTag(from content: String) -> String {
        guard content.hasPrefix("<?xml") else { return content }
        if let xmlTagEndRange = content.range(of: "?>") {
            return String(content[xmlTagEndRange.upperBound...])
        }
        return content
    }

    private func updateSVGTag(for file: File, in content: String) -> String {
        var modifiedContent = content
        let svgTagPattern = "<svg[^>]*>"
        if let svgTagRange = modifiedContent.range(of: svgTagPattern, options: .regularExpression) {
            var svgTag = String(modifiedContent[svgTagRange])
            let viewBoxValue = "\(file.viewBox[0]) \(file.viewBox[1]) \(file.viewBox[2]) \(file.viewBox[3])"
            svgTag = svgTag.replacingOccurrences(of: #"width="[^"]*""#, with: "", options: .regularExpression)
            svgTag = svgTag.replacingOccurrences(of: #"height="[^"]*""#, with: "", options: .regularExpression)
            if svgTag.contains("viewBox=\"") {
                svgTag = svgTag.replacingOccurrences(of: #"viewBox="[^"]*""#, with: "viewBox=\"\(viewBoxValue)\"", options: .regularExpression)
            } else {
                svgTag = svgTag.replacingOccurrences(of: "<svg", with: "<svg viewBox=\"\(viewBoxValue)\"")
            }
            if !file.className.isEmpty {
                if !svgTag.contains("class=\"") {
                    svgTag = svgTag.replacingOccurrences(of: "<svg", with: "<svg class=\"\(file.className)\"")
                }
            }
            modifiedContent.replaceSubrange(svgTagRange, with: svgTag)
        }
        return modifiedContent
    }

    private func updatePathTags(for file: File, in content: String) -> String {
        guard !file.fill.isEmpty else { return content }
        var modifiedContent = content
        let pathPattern = "<path[^>]*>"
        let pathRegex = try! NSRegularExpression(pattern: pathPattern, options: [])
        let pathMatches = pathRegex.matches(in: modifiedContent, options: [], range: NSRange(location: 0, length: modifiedContent.utf16.count))

        for match in pathMatches.reversed() {
            if let pathRange = Range(match.range, in: modifiedContent) {
                var pathTag = String(modifiedContent[pathRange])
                if !pathTag.contains("fill=\"") {
                    pathTag = pathTag.replacingOccurrences(of: "<path", with: "<path fill=\"\(file.fill)\"")
                    modifiedContent.replaceSubrange(pathRange, with: pathTag)
                }
            }
        }
        return modifiedContent
    }

    private func toggleSelectAll() {
        selectAll.toggle()
        files.indices.forEach { files[$0].isSelected = selectAll }
    }

    private func removeFile(file: File) {
        if let index = files.firstIndex(where: { $0.id == file.id }) {
            files.remove(at: index)
        }
    }

    private func applyBulkEdit() {
        for index in files.indices {
            if files[index].isSelected {
                if !bulkEditSettings.viewBox.allSatisfy({ $0.isEmpty }) {
                    files[index].viewBox = bulkEditSettings.viewBox
                }
                if !bulkEditSettings.className.isEmpty {
                    files[index].className = bulkEditSettings.className
                }
                if !bulkEditSettings.fill.isEmpty {
                    files[index].fill = bulkEditSettings.fill
                }
                if !bulkEditSettings.prefix.isEmpty {
                    files[index].prefix = bulkEditSettings.prefix
                }
            }
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
