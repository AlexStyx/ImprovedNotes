//
//  NoteNoteViewInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - View Input
protocol NoteViewInput: AnyObject {
    func update(with note: NoteViewModel)
        
}

// MARK: - View Output
protocol NoteViewOutput {
    func didTriggerViewReadyEvent()
    func didTriggerViewWillAppearEvent()
    func didTapDismissButton()
}
