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
    func update(with viewModel: NotesListViewModel)
    func performBatchUpdate(with viewModel: NotesListViewModel, changeItems: [ChangeItem])
}

// MARK: - View Output
protocol NotesListViewOutput {
    func didTriggerViewReadyEvent()
    func didTriggerViewWillAppearEvent()
    func didTapAddNoteButton()
    func didTapGoToFoldersButton()
    func didSetEditing(to editing: Bool)
    func didSelectNote(at index: Int)
}
