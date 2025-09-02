//
//  FolderListView.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-08-27.
//

import SwiftUI

struct FolderListView: View {
    @Binding var folder: Folder   // <-- Binding, not copy
    @ObservedObject var folderViewModel: NoteManagerViewModel
    @State private var showingSheet = false

    var body: some View {
        List {
            ForEach(folder.subfolders) { sub in
                NavigationLink(
                    sub.name,
                    destination: FolderListView(folder: binding(for: sub), folderViewModel: folderViewModel)
                )
            }

            if !folder.notes.isEmpty {
                Section(header: Text("Unfiled Notes")) {
                    ForEach(folder.notes) { note in
                        Text(note.title)
                    }
                }
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    AddNoteSheetView(viewModel: folderViewModel, parentFolder: folder)
                }
            }
        }
    }

    private func binding(for subfolder: Folder) -> Binding<Folder> {
        guard let index = folder.subfolders.firstIndex(where: { $0.id == subfolder.id }) else {
            fatalError("Subfolder not found")
        }
        return $folder.subfolders[index]
    }
}


//#Preview {
//    FolderListView(folder:)
//}
