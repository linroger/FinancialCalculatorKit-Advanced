//
//  DocumentListView.swift
//  FinancialCalculatorKit
//
//  Created by Roger Lin on 6/12/25.
//

import SwiftUI
import LaTeXSwiftUI

struct DocumentListView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var currentDocument: EquationDocument
    
    @State private var documents: [EquationDocument] = []
    @State private var searchText: String = ""
    @State private var selectedSortOption: SortOption = .modified
    @State private var showingNewDocumentSheet: Bool = false
    @State private var documentToDelete: EquationDocument?
    @State private var showingDeleteAlert: Bool = false
    
    enum SortOption: String, CaseIterable, Identifiable {
        case title = "Title"
        case created = "Created"
        case modified = "Modified"
        case lineCount = "Line Count"
        
        var id: String { rawValue }
    }
    
    var filteredAndSortedDocuments: [EquationDocument] {
        var filtered = documents
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { document in
                document.title.localizedCaseInsensitiveContains(searchText) ||
                document.subtitle.localizedCaseInsensitiveContains(searchText) ||
                document.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Sort by selected option
        switch selectedSortOption {
        case .title:
            return filtered.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .created:
            return filtered.sorted { $0.created > $1.created }
        case .modified:
            return filtered.sorted { $0.modified > $1.modified }
        case .lineCount:
            return filtered.sorted { $0.lines.count > $1.lines.count }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with search and controls
                headerSection
                
                // Documents grid
                documentsSection
            }
            .padding(24)
            .navigationTitle("Document Library")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("New Document") {
                        showingNewDocumentSheet = true
                    }
                }
            }
        }
        .frame(width: 1000, height: 700)
        .onAppear {
            loadDocuments()
        }
        .alert("Delete Document", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let document = documentToDelete {
                    deleteDocument(document)
                }
            }
        } message: {
            if let document = documentToDelete {
                Text("Are you sure you want to delete '\(document.title)'? This action cannot be undone.")
            }
        }
        .sheet(isPresented: $showingNewDocumentSheet) {
            NewDocumentView(documents: $documents)
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        GroupBox("Library Controls") {
            VStack(spacing: 16) {
                HStack {
                    // Search
                    TextField("Search documents...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 300)
                    
                    Spacer()
                    
                    // Sort picker
                    HStack {
                        Text("Sort by:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Sort", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 300)
                    }
                }
                
                // Statistics
                HStack(spacing: 40) {
                    VStack {
                        Text("\(documents.count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("Total Documents")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(documents.reduce(0) { $0 + $1.lines.count })")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("Total Equations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(documents.filter { $0.isFavorite }.count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        Text("Favorites")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var documentsSection: some View {
        GroupBox("Documents") {
            if filteredAndSortedDocuments.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                        ForEach(filteredAndSortedDocuments, id: \.id) { document in
                            documentCardView(document)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .groupBoxStyle(FinancialGroupBoxStyle())
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Documents Found")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if searchText.isEmpty {
                    Text("Create your first equation document to get started")
                        .font(.body)
                        .foregroundColor(.secondary)
                } else {
                    Text("No documents match '\(searchText)'")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            Button("Create New Document") {
                showingNewDocumentSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
    
    @ViewBuilder
    private func documentCardView(_ document: EquationDocument) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    if !document.subtitle.isEmpty {
                        Text(document.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    toggleFavorite(document)
                }) {
                    Image(systemName: document.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(document.isFavorite ? .red : .secondary)
                }
                .buttonStyle(.plain)
                .help(document.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
            
            // Preview of equations
            if !document.lines.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent Equations:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(Array(document.getSortedLines().prefix(3)), id: \.id) { line in
                        HStack {
                            if !line.latexExpression.isEmpty {
                                LaTeX(line.latexExpression)
                                    .frame(height: 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text(line.expression)
                                    .font(.system(.caption, design: .monospaced))
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(6)
            } else {
                Text("Empty document")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
                    .cornerRadius(6)
            }
            
            // Metadata
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label("\(document.lines.count) equations", systemImage: "function")
                    Spacer()
                    Text(document.modified, style: .relative)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if !document.tags.isEmpty {
                    HStack {
                        ForEach(document.tags.prefix(3), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                        
                        if document.tags.count > 3 {
                            Text("+\(document.tags.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
            
            // Action buttons
            HStack {
                Button("Open") {
                    openDocument(document)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Duplicate") {
                    duplicateDocument(document)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
                
                Menu {
                    Button("Export as LaTeX") {
                        exportDocument(document, format: DocumentExportFormat.latex)
                    }
                    
                    Button("Export as Markdown") {
                        exportDocument(document, format: DocumentExportFormat.markdown)
                    }
                    
                    Button("Export as Plain Text") {
                        exportDocument(document, format: DocumentExportFormat.plainText)
                    }
                    
                    Divider()
                    
                    Button("Delete", role: .destructive) {
                        documentToDelete = document
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
                .menuStyle(.borderlessButton)
                .help("More options")
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(document.id == currentDocument.id ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
    
    // MARK: - Actions
    
    private func loadDocuments() {
        // In a real implementation, this would load from SwiftData
        // For now, creating sample documents
        documents = createSampleDocuments()
    }
    
    private func openDocument(_ document: EquationDocument) {
        currentDocument = document
        dismiss()
    }
    
    private func duplicateDocument(_ document: EquationDocument) {
        let duplicate = EquationDocument(
            title: "\(document.title) (Copy)",
            subtitle: document.subtitle
        )
        
        // Copy all lines
        for line in document.getSortedLines() {
            let duplicateLine = EquationLine(
                expression: line.expression,
                latexExpression: line.latexExpression,
                result: line.result,
                isVariable: line.isVariable,
                variableName: line.variableName,
                orderIndex: line.orderIndex
            )
            duplicate.addLine(duplicateLine)
        }
        
        duplicate.tags = document.tags
        documents.append(duplicate)
    }
    
    private func deleteDocument(_ document: EquationDocument) {
        documents.removeAll { $0.id == document.id }
    }
    
    private func toggleFavorite(_ document: EquationDocument) {
        document.isFavorite.toggle()
    }
    
    private func exportDocument(_ document: EquationDocument, format: DocumentExportFormat) {
        // Implementation for exporting document
        let exportedContent = document.export(format: format)
        
        // In a real implementation, this would show a save dialog
        print("Exporting document '\(document.title)' as \(format.rawValue):")
        print(exportedContent)
    }
    
    private func createSampleDocuments() -> [EquationDocument] {
        let sample1 = EquationDocument(title: "Physics Formulas", subtitle: "Common physics equations")
        sample1.addLine(EquationLine(
            expression: "F = m * a",
            latexExpression: "$F = ma$",
            result: "",
            isVariable: false
        ))
        sample1.addLine(EquationLine(
            expression: "E = m * c^2",
            latexExpression: "$E = mc^2$",
            result: "",
            isVariable: false
        ))
        sample1.tags = ["physics", "formulas", "fundamental"]
        
        let sample2 = EquationDocument(title: "Calculus Examples", subtitle: "Derivatives and integrals")
        sample2.addLine(EquationLine(
            expression: "d/dx[x^2] = 2*x",
            latexExpression: "$\\frac{d}{dx}[x^2] = 2x$",
            result: "",
            isVariable: false
        ))
        sample2.tags = ["calculus", "derivatives", "mathematics"]
        
        return [sample1, sample2]
    }
}

// MARK: - New Document View

struct NewDocumentView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var documents: [EquationDocument]
    
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var tags: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                GroupBox("Document Information") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Title")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            TextField("Enter document title", text: $title)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Subtitle (optional)")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            TextField("Enter subtitle", text: $subtitle)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tags (comma-separated)")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            TextField("e.g., physics, calculus, geometry", text: $tags)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding(16)
                }
                .groupBoxStyle(FinancialGroupBoxStyle())
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("New Document")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Create") {
                        createDocument()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .frame(width: 500, height: 350)
    }
    
    private func createDocument() {
        let newDocument = EquationDocument(
            title: title.isEmpty ? "Untitled Document" : title,
            subtitle: subtitle
        )
        
        if !tags.isEmpty {
            newDocument.tags = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        }
        
        documents.append(newDocument)
        dismiss()
    }
}

#Preview {
    DocumentListView(currentDocument: .constant(EquationDocument()))
}