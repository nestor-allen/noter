//
//  NoteManagerViewModel.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-24.
//

import Foundation
import SwiftUI

class NoteManagerViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    @Published var notes: [Note] = []
    
    private let fileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("data.json")
    
    private struct SavedData: Codable {
        var folders: [Folder]
        var notes: [Note]
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: fileURL)
            let saved = try JSONDecoder().decode(SavedData.self, from: data)
            folders = saved.folders
            notes = saved.notes
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(SavedData(folders: folders, notes: notes))
            try data.write(to: fileURL)
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    func addFolder(name: String) {
        let newFolder = Folder(id: UUID(), name: name, notes: [])
        folders.append(newFolder)
        saveData()
    }
    
    func deleteFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
        saveData()
    }
    
    func renameFolder(_ folder: Folder, newName: String) {
            if let index = folders.firstIndex(where: { $0.id == folder.id }) {
                folders[index].name = newName
                saveData()
            }
    }
    
    func addNote(title: String, type: NoteType, toFolder: Folder? = nil) {
            let newNote = Note(
                id: UUID(),
                title: title,
                type: type,
                content: type == .markdown ? "" : nil,
                drawingData: nil,
                dateCreated: Date(),
                dateModified: Date()
            )
            if let folder = toFolder,
               let index = folders.firstIndex(where: { $0.id == folder.id }) {
                folders[index].notes.insert(newNote, at: 0)
            } else {
                notes.insert(newNote, at: 0)
            }
            saveData()
        }
    
    func deleteNote(_ note: Note) {
            if let index = notes.firstIndex(where: { $0.id == note.id }) {
                notes.remove(at: index)
            } else {
                for i in folders.indices {
                    if let noteIndex = folders[i].notes.firstIndex(where: { $0.id == note.id }) {
                        folders[i].notes.remove(at: noteIndex)
                        break
                    }
                }
            }
            saveData()
        }

}
