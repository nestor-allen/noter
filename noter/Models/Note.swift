//
//  Note.swift
//  noter
//
//  Created by Nestor Allen Obiacoro on 2025-03-22.
//

import Foundation

enum NoteType: String, Codable{
    case normal
    case markdown
    case handwritten
}

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var type: NoteType
    var content: String?
    var drawingData: Data?
    var dateCreated: Date
    var dateModified: Date
}
