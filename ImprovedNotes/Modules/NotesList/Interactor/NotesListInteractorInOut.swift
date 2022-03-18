//
//  NotesListNotesListInteractorInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - Interactor Input
protocol NotesListInteractorInput {
    func loadData(with sortValue: SortValue?) 
}

// MARK: - Interactor Output
protocol NotesListInteractorOutput: AnyObject {
    func didChangeList(notes: [Note])
    func performBatchUpdate(changeItems: [ChangeItem])
}
