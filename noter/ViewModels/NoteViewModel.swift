//
//  NoteViewModel.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-22.
//

import Foundation

class NoteViewModel {
    @Published var notes: [Note] = []
    
    private let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("notes.json")
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        do {
            let data = try Data(contentsOf: fileURL)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("No notes available")
        }
    }
    
    func createNote (title: String, of type: NoteType) {
        let newNote = Note(
            id: UUID(),
            title: title,
            type: type,
            content: type == .markdown ? "" : nil,
            dateCreated: Date(),
            dateModified: Date()
        )
        notes.insert(newNote, at: 0)
        saveNotes()
    }
    
    func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save notes: \(error)")
        }
    }
}
