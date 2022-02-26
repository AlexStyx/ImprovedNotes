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
    
}


// MARK: - Module Input
extension NotesListPresenter: NotesListModuleInput {
   
    
}


// MARK: - Interactor Output
extension NotesListPresenter: NotesListInteractorOutput {
    func didChangeList(notes: [Note]) {
        for note in notes {
            let noteViewModel = NoteViewModel(note: note)
            viewModel.notes.append(noteViewModel)
        }
        view?.update(with: viewModel)
    }
}


// MARK: - View Output
extension NotesListPresenter: NotesListViewOutput {
    
    func didTriggerViewReadyEvent() {
        interactor?.loadData(with: nil)
    }
    
    func didTriggerViewWillAppearEvent() {
        
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
