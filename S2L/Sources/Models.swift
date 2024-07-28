import Foundation

// A model representing the directories used in the application.
struct Directories {
    var inputDirectory: String = ""
    var outputDirectory: String = ""
}

// A model representing the state of various modals in the application.
struct Modals {

    var showingHelpModal = false
    var showingBulkEditModal = false
    var showingAboutModal = false
    var showingFeedbackModal = false
}
