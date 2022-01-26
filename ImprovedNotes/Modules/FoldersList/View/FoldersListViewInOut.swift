//
//  FoldersListFoldersListViewInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - View Input
protocol FoldersListViewInput: AnyObject {
    
}

// MARK: - View Output
protocol FoldersListViewOutput {
    func didTriggerViewReadyEvent()
    func didTriggerViewWillAppearEvent()
}