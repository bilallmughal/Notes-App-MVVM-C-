//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @ObservedObject var viewModel: NoteDetailViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title Field
                TextField("Title", text: $viewModel.title)
                    .font(.system(size: 24, weight: .bold))
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .title)
                
                // Category and Pin Section
                HStack {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(Note.Category.allCases, id: \.self) { category in
                            Label(category.rawValue.capitalized, 
                                  systemImage: category.icon)
                                .foregroundColor(Color(category.color))
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Spacer()
                    
                    Button {
                        viewModel.isPinned.toggle()
                    } label: {
                        Image(systemName: viewModel.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(viewModel.isPinned ? .yellow : .gray)
                    }
                }
                .padding(.vertical, 8)
                
                // Tags Section
                TagsView(tags: $viewModel.tags)
                
                // Content Section
                TextEditor(text: $viewModel.content)
                    .font(.body)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .content)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func save() {
        do {
            try viewModel.saveNote()
            coordinator.navigateBack()
        } catch {
            print("Error saving note: \(error)")
        }
    }
}

struct TagsView: View {
    @Binding var tags: Set<String>
    @State private var newTag: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Existing tags
            FlowLayout(spacing: 8) {
                ForEach(Array(tags), id: \.self) { tag in
                    TagView(tag: tag) {
                        tags.remove(tag)
                    }
                }
            }
            
            // Add new tag
            HStack {
                TextField("Add tag...", text: $newTag)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        addTag()
                    }
                
                Button(action: addTag) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newTag.isEmpty)
            }
        }
    }
    
    private func addTag() {
        let tag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty {
            tags.insert(tag)
            newTag = ""
        }
    }
}

struct TagView: View {
    let tag: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.caption)
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0
        var width: CGFloat = 0
        
        for row in rows {
            let rowSize = rowSize(for: row)
            height += rowSize.height
            width = max(width, rowSize.width)
            if row != rows.last {
                height += spacing
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(width: size.width, height: size.height)
                )
                x += size.width + spacing
            }
            
            y += rowHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var rows: [[LayoutSubviews.Element]] = []
        var currentRow: [LayoutSubviews.Element] = []
        var currentWidth: CGFloat = 0
        
        let maxWidth = proposal.width ?? .infinity
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentWidth + size.width > maxWidth && !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = [subview]
                currentWidth = size.width + spacing
            } else {
                currentRow.append(subview)
                currentWidth += size.width + spacing
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private func rowSize(for row: [LayoutSubviews.Element]) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        for (index, subview) in row.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            width += size.width
            if index < row.count - 1 {
                width += spacing
            }
            height = max(height, size.height)
        }
        
        return CGSize(width: width, height: height)
    }
} 
