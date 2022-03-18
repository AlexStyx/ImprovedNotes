//
//  NotesListNotesListPresenter.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

final class NotesListPresenter: NSObject {
    
    weak var view: NotesListViewInput?
    var interactor: NotesListInteractorInput?
    var router: NotesListRouterInput?
    weak var moduleOutput: NotesListModuleOutput?
    
    // MARK: - Private
    
    private var viewModel = NotesListViewModel(notes: [], isEditing: false)
    
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidSelectCurrentFolderNotification), name: NSNotification.Name(DidSelectCurrentFolderNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func handleDidSelectCurrentFolderNotification() {
        interactor?.loadData(with: nil)
    }
    
}


// MARK: - Module Input
extension NotesListPresenter: NotesListModuleInput {
   
    
}


// MARK: - Interactor Output
extension NotesListPresenter: NotesListInteractorOutput {
    func didChangeList(notes: [Note]) {
        var newViewModels = [NoteViewModel]()
        for note in notes {
            let noteViewModel = NoteViewModel(note: note)
            newViewModels.append(noteViewModel)
        }
        viewModel.notes = newViewModels
        view?.update(with: viewModel)
    }
    
    func performBatchUpdate(changeItems: [ChangeItem]) {
        for change in changeItems {
            guard let note = change.object as? Note else { return }
            switch (change.type) {
            case .insert:
                guard let index = change.newIndexPath?.row else { return }
                let folderViewModel = NoteViewModel(note: note)
                viewModel.notes.insert(folderViewModel, at: index)
            case .delete:
                guard let index = change.indexPath?.row else { return }
                viewModel.notes.remove(at: index)
            case .move:
                guard let sourceIndex = change.indexPath?.row,
                      let destinationIndex = change.newIndexPath?.row
                else { return }
                viewModel.notes.swapAt(sourceIndex, destinationIndex)
            case .update:
                guard let index = change.indexPath?.row else { return }
                let updatedFolderViewModel = NoteViewModel(note: note)
                viewModel.notes[index] = updatedFolderViewModel
            @unknown default:
                return
            }
        }
        view?.performBatchUpdate(with: viewModel, changeItems: changeItems)
    }
}


// MARK: - View Output
extension NotesListPresenter: NotesListViewOutput {
    
    func didTriggerViewReadyEvent() {
        interactor?.loadData(with: nil)
    }
    
    func didTriggerViewWillAppearEvent() {
        interactor?.loadData(with: nil)
    }
    
    func didTapAddNoteButton() {
        router?.openNoteModule(with: NoteViewModel(title: "Test title", dateString: Date().dateString(), isSelected: false, isEditing: false, id: UUID()))
    }
    
    func didTapGoToFoldersButton() {
        router?.openFoldersListModule()
    }
    
    func didSetEditing(to editing: Bool) {
        viewModel.isEditing = editing
        for index in 0..<viewModel.notes.count {
            viewModel.notes[index].isEditing = editing
            if (!editing) {
                viewModel.notes[index].isSelected = false
            }
        }
        if (!editing) {
            viewModel.moveToActionTitle = "Move All"
            viewModel.removeActionTitle = "Remove All"
        }
        view?.update(with: viewModel)
    }
    
    func didSelectNote(at index: Int) {
        if viewModel.isEditing {
            viewModel.notes[index].isSelected = !viewModel.notes[index].isSelected
            
            let isNumberOfSelecteditemsGreaterThanZero = viewModel.notes.filter({ $0.isSelected }).count != 0
            viewModel.moveToActionTitle = isNumberOfSelecteditemsGreaterThanZero ? "Move" : "Move All"
            viewModel.removeActionTitle = isNumberOfSelecteditemsGreaterThanZero ? "Remove": "Remove All"
        } else {
            let note = viewModel.notes[index]
            router?.openNoteModule(with: note)
        }
        view?.update(with: viewModel)
    }
    
}
