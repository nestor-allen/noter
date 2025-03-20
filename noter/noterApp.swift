//
//  noterApp.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-20.
//

import SwiftUI

@main
struct noterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
