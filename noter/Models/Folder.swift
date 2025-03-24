//
//  Folder.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-24.
//

import Foundation

struct Folder: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var notes: [Note]
}
