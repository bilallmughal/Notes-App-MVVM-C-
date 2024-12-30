//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import Foundation
import Combine

class NotesListViewModel: ObservableObject {
    @Published var notes: [Note] = []
    private let storage: NotesStorageProtocol
    
    var pinnedNotes: [Note] {
        notes.filter { $0.isPinned }.sorted { $0.lastModified > $1.lastModified }
    }
    
    var unpinnedNotes: [Note] {
        notes.filter { !$0.isPinned }.sorted { $0.lastModified > $1.lastModified }
    }
    
    init(storage: NotesStorageProtocol = NotesStorage()) {
        self.storage = storage
        loadNotes()
    }
    
    func loadNotes() {
        do {
            notes = try storage.loadNotes()
        } catch {
            print("Error loading notes: \(error)")
        }
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
        saveNotes()
    }
    
    private func saveNotes() {
        do {
            try storage.saveNotes(notes)
        } catch {
            print("Error saving notes: \(error)")
        }
    }
} 
