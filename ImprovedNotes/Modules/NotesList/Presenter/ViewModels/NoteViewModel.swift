//
//  NoteViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/19/22.
//

import UIKit

struct NoteViewModel {
    let title: String
    let dateString: String
    var isSelected: Bool
    var isEditing: Bool
    
    
    init(title: String, dateString: String, isSelected: Bool, isEditing: Bool) {
        self.title = title
        self.dateString = dateString
        self.isSelected = isSelected
        self.isEditing = isEditing
    }
    init(note: Note) {
        title = note.title ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateString = dateFormatter.string(from: note.dateCreated ?? Date())
        self.isEditing = false
        self.isSelected = false
    }
    
    mutating func setEditing(_ editing: Bool) {
        isEditing = editing
    }
    
}
