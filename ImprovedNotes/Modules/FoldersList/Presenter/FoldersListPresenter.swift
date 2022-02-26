//
//  FoldersListFoldersListPresenter.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

final class FoldersListPresenter: NSObject {
    
    weak var view: FoldersListViewInput?
    var interactor: FoldersListInteractorInput?
    var router: FoldersListRouterInput?
    weak var moduleOutput: FoldersListModuleOutput?
    
    // MARK: - Private
    private var viewModel = FoldersListViewModel()
}


// MARK: - Module Input
extension FoldersListPresenter: FoldersListModuleInput {
    
}


// MARK: - Interactor Output
extension FoldersListPresenter: FoldersListInteractorOutput {
    func didChangeList(folders: [Folder]) {
        var folderViewModels = [FolderViewModel]()
        for folder in folders {
            let folderViewModel = FolderViewModel(folder: folder)
            folderViewModels.append(folderViewModel)
        }
        viewModel.folders = folderViewModels
        view?.update(with: viewModel)
    }
    
    
    func performBatchUpdate(changeItems: [ChangeItem]) {
        for change in changeItems {
            guard let folder = change.object as? Folder else { return }
            switch (change.type) {
            case .insert:
                guard let index = change.newIndexPath?.row else { return }
                let folderViewModel = FolderViewModel(folder: folder)
                viewModel.folders.insert(folderViewModel, at: index)
            case .delete:
                guard let index = change.indexPath?.row else { return }
                viewModel.folders.remove(at: index)
            case .move:
                guard let sourceIndex = change.indexPath?.row,
                      let destinationIndex = change.newIndexPath?.row
                else { return }
                viewModel.folders.swapAt(sourceIndex, destinationIndex)
            case .update:
                guard let index = change.indexPath?.row else { return }
                let updatedFolderViewModel = FolderViewModel(folder: folder)
                viewModel.folders[index] = updatedFolderViewModel
            @unknown default:
                return
            }
        }
        view?.performBatchUpdate(with: viewModel, folderChangeItems: changeItems)
    }
}


// MARK: - View Output
extension FoldersListPresenter: FoldersListViewOutput {
    
    func didTriggerViewReadyEvent() {
        interactor?.loadData()
    }
    
    func didTriggerViewWillAppearEvent() {
        
    }
    
    func didSelectFolder(at index: Int) {
        let folderViewModel = viewModel.folders[index]
        interactor?.didSelectFolder(withId: folderViewModel.id)
    }
    
    func didTapAddNoteButton(title: String) {
        interactor?.addFolder(title: title)
    }
    
    func didTapRemoveButton(at index: Int) {
        let folderViewModel = viewModel.folders[index]
        interactor?.removeFolder(withId: folderViewModel.id)
    }
    
    func didTapRename(at index: Int, newTitle: String) {
        let folderViewModel = viewModel.folders[index]
        interactor?.renameFolder(withId: folderViewModel.id, newTitle: newTitle)
    }
    
    func searchFolders(with term: String) {
        interactor?.searchFolders(with: term)
    }
    
    func stopSearching() {
        interactor?.stopSeaching()
    }
   
    
}
