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
    func update(with viewModel: FoldersListViewModel)
    func performBatchUpdate(with viewModel: FoldersListViewModel, folderChangeItems: [ChangeItem])
}

// MARK: - View Output
protocol FoldersListViewOutput {
    func didTriggerViewReadyEvent()
    func didTriggerViewWillAppearEvent()
    func didSelectFolder(at index: Int)
    func didTapAddNoteButton(title: String)
    func didTapRemoveButton(at index: Int)
    func didTapRename(at index: Int, newTitle: String)
    func searchFolders(with term: String)
    func stopSearching()
}
