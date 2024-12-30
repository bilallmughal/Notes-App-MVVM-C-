//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import Foundation
import Combine

class NoteDetailViewModel: ObservableObject {
    @Published var title: String
    @Published var content: String
    @Published var category: Note.Category
    @Published var isPinned: Bool
    @Published var tags: Set<String>
    
    private let storage: NotesStorageProtocol
    private let existingNote: Note?
    
    init(note: Note? = nil, storage: NotesStorageProtocol = NotesStorage()) {
        self.existingNote = note
        self.storage = storage
        self.title = note?.title ?? ""
        self.content = note?.content ?? ""
        self.category = note?.category ?? .other
        self.isPinned = note?.isPinned ?? false
        self.tags = note?.tags ?? []
    }
    
    func saveNote() throws {
        var notes = try storage.loadNotes()
        let updatedNote = Note(
            id: existingNote?.id ?? UUID(),
            title: title,
            content: content,
            lastModified: Date(),
            isPinned: isPinned,
            category: category,
            tags: tags
        )
        
        if let existingNote = existingNote,
           let index = notes.firstIndex(where: { $0.id == existingNote.id }) {
            notes[index] = updatedNote
        } else {
            notes.append(updatedNote)
        }
        
        try storage.saveNotes(notes)
    }
} 
