//
//  NoteViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/19/22.
//

import UIKit
import CloudKit

struct NoteViewModel {
    let title: String
    let dateString: String
    var isSelected: Bool
    var isEditing: Bool
    var id: UUID
    
    
    init(title: String, dateString: String, isSelected: Bool, isEditing: Bool, id: UUID) {
        self.title = title
        self.dateString = dateString
        self.isSelected = isSelected
        self.isEditing = isEditing
        self.id = id
    }
    
    init(note: Note) {
        title = note.title ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateString = dateFormatter.string(from: note.dateCreated ?? Date())
        self.isEditing = false
        self.isSelected = false
        self.id = note.id ?? UUID()
    }
    
}

extension NoteViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
