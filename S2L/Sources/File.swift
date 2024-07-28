import Foundation

// A model representing a file with various attributes.
struct File: Identifiable {
    var id = UUID()
    var name: String
    // The viewBox dimensions of the file as an array of strings (x, y, width, height).
    var viewBox: [String]
    var className: String
    var fill: String
    // Adds a custom prefix string the start of a file name.
    var prefix: String
    var isSelected: Bool = false
}
