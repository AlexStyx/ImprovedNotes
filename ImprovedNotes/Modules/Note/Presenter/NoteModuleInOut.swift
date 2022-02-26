//
//  NoteNoteModuleInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - Module Input
@objc
protocol NoteModuleInput {
    func setup(with note: Any)
}

// MARK: - Module Output
@objc
protocol NoteModuleOutput {
    
}
