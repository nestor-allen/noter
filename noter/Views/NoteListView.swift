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
        NavigationStack {
            List {
                ForEach(viewModel.folders) { folder in
                    Section(header: Text(folder.name)) {
                        ForEach(folder.notes) { note in
                            Text(note.title)
                        }
                    }
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
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("+") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            AddNoteSheetView()
                        }
                }
            }
        }
    }
    
}


struct AddNoteSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack{
            Button("Cancel") {
                dismiss()
            }
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.top)
            Button ("Add") {
                
            }
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing)
            .padding(.top)
        }
        Form {
            Section("Add"){
                
            }
        }
    }
    
}

#Preview {
    NoteListView()
}
