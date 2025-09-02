//
//  AddNoteSheetView.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-08-29.
//

import SwiftUI

struct AddNoteSheetView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedType") var selectedType = 0
    @State private var selectedFolderID: UUID? = nil
    @ObservedObject var viewModel: NoteManagerViewModel
    @State private var name: String = ""

    let parentFolder: Folder?

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top)

                Button("Add") {
                    if selectedType == 0 {
                        let targetFolder: Folder? =
                            selectedFolderID == nil ? nil : parentFolder
                        viewModel.addFolder(name: name, to: targetFolder)
                    } else {
                        let targetFolder: Folder? =
                            selectedFolderID == nil ? nil : parentFolder
                        viewModel.addNote(title: name, type: .normal, toFolder: targetFolder)
                    }
                    dismiss()
                }
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                .padding(.top)
            }

            Form {
                Picker("Select Type", selection: $selectedType) {
                    Text("Folder").tag(0)
                    Text("File").tag(1)
                }
                .pickerStyle(.inline)

                Section("Name") {
                    TextField(selectedType == 0 ? "Folder Name" : "File Name", text: $name)
                }

                // Folder picker (only root + parent folder)
                if selectedType == 0 {
                    Section("Parent Folder") {
                        Picker("Parent Folder", selection: $selectedFolderID) {
                            Text("Root").tag(UUID?.none)
                            if let parent = parentFolder {
                                Text(parent.name).tag(Optional(parent.id))
                            }
                        }
                    }
                }

                // Note picker (only root + parent folder)
                if selectedType == 1 {
                    Section("Location") {
                        Picker("Location", selection: $selectedFolderID) {
                            Text("Unfiled").tag(UUID?.none)
                            if let parent = parentFolder {
                                Text(parent.name).tag(Optional(parent.id))
                            }
                        }
                    }
                }
            }
        }
    }
}
