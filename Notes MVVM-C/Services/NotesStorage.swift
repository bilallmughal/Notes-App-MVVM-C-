//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import Foundation

protocol NotesStorageProtocol {
    func saveNotes(_ notes: [Note]) throws
    func loadNotes() throws -> [Note]
}

class NotesStorage: NotesStorageProtocol {
    private let userDefaults: UserDefaults
    private let notesKey = "savedNotes"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveNotes(_ notes: [Note]) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(notes)
        userDefaults.set(data, forKey: notesKey)
    }
    
    func loadNotes() throws -> [Note] {
        guard let data = userDefaults.data(forKey: notesKey) else { return [] }
        let decoder = JSONDecoder()
        return try decoder.decode([Note].self, from: data)
    }
} 
