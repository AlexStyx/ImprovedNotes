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
    
    // edit
    func didTapRename(at index: Int, newTitle: String)
    func didSelectFolder(at index: Int)
    func didTapAddNoteButton(title: String)
    func didTapRemoveButton(at index: Int)

    // search
    func searchFolders(with term: String)
    func stopSearching()
    
    // sort
    func didSwapRows(sourceIndex: Int, destinationIndex: Int)
    func finishDragging(at index: Int)
    
}
