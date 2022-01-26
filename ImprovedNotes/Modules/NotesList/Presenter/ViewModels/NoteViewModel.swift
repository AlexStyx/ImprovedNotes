//
//  NoteViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/19/22.
//

import Foundation

struct NoteViewModel {
    let title: String
    let dateString: String
    
    init(note: Note) {
        title = note.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateString = dateFormatter.string(from: note.date)
    }
}
