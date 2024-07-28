import Foundation
//asd
struct File: Identifiable {
    var id = UUID()
    var name: String
    var viewport: [String]
    var className: String
    var fill: String
    var prefix: String
    var isSelected: Bool = false
}
