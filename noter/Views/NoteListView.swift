//
//  NoteListView.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-22.
//

import SwiftUI

struct NoteListView: View {
    @StateObject private var viewModel = NoteManagerViewModel()
    @State private var showingSheet = false

    var body: some View {
        // Using a navigation stack and will use links to all the other pages (notes/folders)
        NavigationStack {
            List {
                //This gives me the list of folders and notes
                ForEach($viewModel.folders) { $folder in
                    NavigationLink(
                        folder.name,
                        destination: FolderListView(folder: $folder, folderViewModel: viewModel)
                    )
                }

                if !viewModel.notes.isEmpty {
                    Section(header: Text("Unfiled Notes")) {
                        ForEach(viewModel.notes) { note in
                            Text(note.title)
                        }
                    }
                }
            }
            .navigationTitle("NOTER")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        AddNoteSheetView(viewModel: viewModel, parentFolder: nil)
                    }
                }
            }
        }
    }

}


#Preview {
    NoteListView()
}
