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
            let data = try JSONEncoder().encode(
                SavedData(folders: folders, notes: notes))
            try data.write(to: fileURL)
        } catch {
            print("Save failed: \(error)")
        }
    }

    func addFolder(name: String, to parentFolder: Folder? = nil) {
        let newFolder = Folder(id: UUID(), name: name, notes: [], subfolders: [])

        if let parentFolder = parentFolder {
            if let index = folders.firstIndex(where: { $0.id == parentFolder.id }) {
                var updated = folders[index]
                updated.subfolders.append(newFolder)
                folders[index] = updated
            } else {
                insertFolder(newFolder, into: &folders, parentID: parentFolder.id)
            }
        } else {
            folders.append(newFolder)
        }

        saveData()
    }
    
    private func insertFolder(_ newFolder: Folder, into folders: inout [Folder], parentID: UUID) {
        for i in folders.indices {
            if folders[i].id == parentID {
                var updated = folders[i]
                updated.subfolders.append(newFolder)
                folders[i] = updated
                return
            } else {
                insertFolder(newFolder, into: &folders[i].subfolders, parentID: parentID)
            }
        }
    }


    func deleteFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
        saveData()
    }

    func findFolder(by id: UUID?) -> Folder? {
        guard let id = id else { return nil }
        return searchFolder(in: folders, id: id)
    }

    private func searchFolder(in folders: [Folder], id: UUID) -> Folder? {
        for folder in folders {
            if folder.id == id {
                return folder
            }
            if let found = searchFolder(in: folder.subfolders, id: id) {
                return found
            }
        }
        return nil
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
            let index = folders.firstIndex(where: { $0.id == folder.id })
        {
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
                if let noteIndex = folders[i].notes.firstIndex(where: {
                    $0.id == note.id
                }) {
                    folders[i].notes.remove(at: noteIndex)
                    break
                }
            }
        }
        saveData()
    }

}
