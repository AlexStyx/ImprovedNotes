//
//  FoldersListFoldersListInteractorInOut.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

// MARK: - Interactor Input
protocol FoldersListInteractorInput {
    func loadData()
    func didSelectFolder(withId id: UUID)
    func addFolder(title: String)
    func removeFolder(withId id: UUID)
    func renameFolder(withId id: UUID, newTitle: String)
    func searchFolders(with term: String)
    func stopSeaching()
}

// MARK: - Interactor Output
protocol FoldersListInteractorOutput: AnyObject {
    func didChangeList(folders: [Folder])
    func performBatchUpdate(changeItems: [ChangeItem])
}
