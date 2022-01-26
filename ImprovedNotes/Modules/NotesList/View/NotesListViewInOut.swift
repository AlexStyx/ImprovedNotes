//
//  NotesListNotesListViewInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - View Input
protocol NotesListViewInput: AnyObject {
    
}

// MARK: - View Output
protocol NotesListViewOutput {
    func didTriggerViewReadyEvent()
    func didTriggerViewWillAppearEvent()
    func didTapAddNoteButton()
    func didTapGoToFoldersButton()
}
