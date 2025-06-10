import Foundation

struct CSVHelper {
    static func export(rows: [[String]], to url: URL) throws {
        let csvString = rows.map { $0.joined(separator: ",") }.joined(separator: "\n")
        try csvString.data(using: .utf8)?.write(to: url)
    }
}
