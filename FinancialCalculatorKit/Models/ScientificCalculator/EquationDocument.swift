//
//  EquationDocument.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import Foundation
import SwiftData

/// An equation line within a document
@Model
class EquationLine {
    var id: UUID
    var expression: String
    var latexExpression: String
    var result: String
    var isVariable: Bool
    var variableName: String
    var timestamp: Date
    var orderIndex: Int
    
    init(expression: String = "", latexExpression: String = "", result: String = "", 
         isVariable: Bool = false, variableName: String = "", orderIndex: Int = 0) {
        self.id = UUID()
        self.expression = expression
        self.latexExpression = latexExpression
        self.result = result
        self.isVariable = isVariable
        self.variableName = variableName
        self.timestamp = Date()
        self.orderIndex = orderIndex
    }
}

/// A document containing multiple equations and calculations
@Model
class EquationDocument {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String
    var created: Date
    var modified: Date
    @Relationship(deleteRule: .cascade, inverse: \EquationLine.document)
    var lines: [EquationLine]
    var tags: [String]
    var isFavorite: Bool
    
    // Computed property for document extension
    var document: EquationDocument? {
        get { self }
        set { }
    }
    
    init(title: String = "Untitled Document", subtitle: String = "") {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.created = Date()
        self.modified = Date()
        self.lines = []
        self.tags = []
        self.isFavorite = false
    }
    
    /// Adds a new equation line
    func addLine(_ line: EquationLine) {
        line.orderIndex = lines.count
        lines.append(line)
        modified = Date()
    }
    
    /// Inserts a line at a specific index
    func insertLine(_ line: EquationLine, at index: Int) {
        let clampedIndex = max(0, min(index, lines.count))
        line.orderIndex = clampedIndex
        lines.insert(line, at: clampedIndex)
        
        // Update order indices for subsequent lines
        for i in (clampedIndex + 1)..<lines.count {
            lines[i].orderIndex = i
        }
        modified = Date()
    }
    
    /// Removes a line at a specific index
    func removeLine(at index: Int) {
        guard index >= 0 && index < lines.count else { return }
        lines.remove(at: index)
        
        // Update order indices for subsequent lines
        for i in index..<lines.count {
            lines[i].orderIndex = i
        }
        modified = Date()
    }
    
    /// Moves a line from one index to another
    func moveLine(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex >= 0 && sourceIndex < lines.count,
              destinationIndex >= 0 && destinationIndex < lines.count else { return }
        
        let line = lines.remove(at: sourceIndex)
        lines.insert(line, at: destinationIndex)
        
        // Update all order indices
        for i in 0..<lines.count {
            lines[i].orderIndex = i
        }
        modified = Date()
    }
    
    /// Gets lines sorted by order index
    func getSortedLines() -> [EquationLine] {
        return lines.sorted { $0.orderIndex < $1.orderIndex }
    }
    
    /// Generates a complete LaTeX representation of the document
    func generateCompleteLatex() -> String {
        var latex = """
        \\documentclass{article}
        \\usepackage{amsmath}
        \\usepackage{amssymb}
        \\usepackage{amsfonts}
        \\begin{document}
        
        \\title{\(title)}
        """
        
        if !subtitle.isEmpty {
            latex += "\n\\subtitle{\(subtitle)}"
        }
        
        latex += """
        
        \\maketitle
        
        \\begin{align}
        """
        
        let sortedLines = getSortedLines()
        for (index, line) in sortedLines.enumerated() {
            if !line.latexExpression.isEmpty {
                if line.isVariable && !line.variableName.isEmpty {
                    latex += "\(line.variableName) &= \(line.latexExpression)"
                    if !line.result.isEmpty && line.result != line.variableName {
                        latex += " = \(line.result)"
                    }
                } else {
                    latex += line.latexExpression
                    if !line.result.isEmpty {
                        latex += " &= \(line.result)"
                    }
                }
                
                if index < sortedLines.count - 1 {
                    latex += " \\\\\n"
                }
            }
        }
        
        latex += """
        
        \\end{align}
        
        \\end{document}
        """
        
        return latex
    }
    
    /// Generates simplified LaTeX for display
    func generateDisplayLatex() -> String {
        let sortedLines = getSortedLines()
        guard !sortedLines.isEmpty else { return "" }
        
        var latex = "\\begin{align}\n"
        
        for (index, line) in sortedLines.enumerated() {
            if !line.latexExpression.isEmpty {
                if line.isVariable && !line.variableName.isEmpty {
                    latex += "\(line.variableName) &= \(line.latexExpression)"
                    if !line.result.isEmpty && line.result != line.variableName {
                        latex += " = \(line.result)"
                    }
                } else {
                    latex += line.latexExpression
                    if !line.result.isEmpty {
                        latex += " &= \(line.result)"
                    }
                }
                
                if index < sortedLines.count - 1 {
                    latex += " \\\\\n"
                } else {
                    latex += " \n"
                }
            }
        }
        
        latex += "\\end{align}"
        return latex
    }
    
    /// Exports document to various formats
    func export(format: DocumentExportFormat) -> String {
        switch format {
        case .latex:
            return generateCompleteLatex()
        case .markdown:
            return generateMarkdown()
        case .plainText:
            return generatePlainText()
        }
    }
    
    private func generateMarkdown() -> String {
        var markdown = "# \(title)\n\n"
        
        if !subtitle.isEmpty {
            markdown += "## \(subtitle)\n\n"
        }
        
        let sortedLines = getSortedLines()
        for line in sortedLines {
            if line.isVariable && !line.variableName.isEmpty {
                markdown += "**\(line.variableName)** = \(line.expression)"
                if !line.result.isEmpty {
                    markdown += " = \(line.result)"
                }
            } else {
                markdown += line.expression
                if !line.result.isEmpty {
                    markdown += " = \(line.result)"
                }
            }
            markdown += "\n\n"
        }
        
        return markdown
    }
    
    private func generatePlainText() -> String {
        var text = "\(title)\n"
        text += String(repeating: "=", count: title.count) + "\n\n"
        
        if !subtitle.isEmpty {
            text += "\(subtitle)\n\n"
        }
        
        let sortedLines = getSortedLines()
        for line in sortedLines {
            if line.isVariable && !line.variableName.isEmpty {
                text += "\(line.variableName) = \(line.expression)"
                if !line.result.isEmpty {
                    text += " = \(line.result)"
                }
            } else {
                text += line.expression
                if !line.result.isEmpty {
                    text += " = \(line.result)"
                }
            }
            text += "\n"
        }
        
        return text
    }
}

// Add the missing relationship property to EquationLine
extension EquationLine {
    var document: EquationDocument? {
        get { nil } // This would be handled by SwiftData
        set { }
    }
}

enum DocumentExportFormat: String, CaseIterable, Identifiable {
    case latex = "LaTeX"
    case markdown = "Markdown"
    case plainText = "Plain Text"
    
    var id: String { rawValue }
    
    var fileExtension: String {
        switch self {
        case .latex: return "tex"
        case .markdown: return "md"
        case .plainText: return "txt"
        }
    }
}