//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import SwiftUI

struct NotesListView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        List {
            if !viewModel.pinnedNotes.isEmpty {
                Section("Pinned") {
                    ForEach(viewModel.pinnedNotes) { note in
                        NoteRowView(note: note)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                coordinator.navigateToDetail(note: note)
                            }
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
            }
            
            Section("Notes") {
                ForEach(viewModel.unpinnedNotes) { note in
                    NoteRowView(note: note)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.navigateToDetail(note: note)
                        }
                }
                .onDelete(perform: viewModel.deleteNote)
            }
        }
        .navigationTitle("Notes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    coordinator.navigateToDetail(note: nil)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .onAppear {
            viewModel.loadNotes()
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("", systemImage: note.category.icon)
                    .foregroundColor(note.category.color)
                
                Text(note.title.isEmpty ? "Untitled Note" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            
            if !note.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(note.tags), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Text(note.lastModified.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        NotesListView(viewModel: NotesListViewModel())
            .environmentObject(MainCoordinator())
    }
} 
