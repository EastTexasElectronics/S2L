import Foundation

struct BulkEditSettings: Identifiable {
    var id = UUID()
    var viewBox: [String] = ["", "", "", ""]
    var className: String = ""
    var fill: String = ""
    var prefix: String = ""
}
