//
//  noterApp.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-22.
//

import SwiftUI

@main
struct noterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NoteListView()
        }
    }
}
