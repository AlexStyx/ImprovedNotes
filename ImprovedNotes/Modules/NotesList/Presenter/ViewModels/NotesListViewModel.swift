//
//  NotesListViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/19/22.
//

import Foundation

struct NotesListViewModel {
    var notes = [NoteViewModel]()
    var isEditing = false
    var moveToActionTitle = "Move All"
    var removeActionTitle = "Remove All"
    
}
