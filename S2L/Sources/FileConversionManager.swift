import Foundation
import AppKit

class FileConversionManager: ObservableObject {
    @Published var directories = Directories()
    @Published var files: [File] = []
    @Published var modals = Modals()
    @Published var logMessages = ""
    @Published var filesConverted = 0
    @Published var feedbackMessage = ""
    @Published var isFeedbackViewPresented = false
    @Published var isProgressViewPresented = false

    var startTime = Date()

    func browseInputDirectory() {
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

    func browseOutputDirectory() {
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

    func clearSelectedFiles() {
        files.removeAll { $0.isSelected }
    }

    func startConversion() {
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
                        return await self.processFile(file)
                    }
                }
                for await result in group {
                    if let message = result {
                        await MainActor.run {
                            self.logMessages += message + "\n"
                        }
                    }
                }
            }
            await MainActor.run {
                if self.filesConverted > 0 {
                    let timeTaken = Date().timeIntervalSince(self.startTime)
                    self.logMessages += "\n\nFile conversions complete.\n"
                    self.logMessages += "Number of Files Converted: \(self.filesConverted)\n"
                    self.logMessages += "Time Taken: \(String(format: "%.2f", timeTaken)) seconds\n"
                    self.logMessages += "Destination Directory: \(self.directories.outputDirectory)"
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
                self.filesConverted += 1
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
}
