//
//  NotesListNotesListRouterInput.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

@objc
protocol NotesListRouterInput: BaseSwiftRouterInput {
    func openNoteModule()
    func openFoldersListModule()
}
