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
    
    private var viewModel: NotesListViewModel = NotesListViewModel(notes: [], isEditing: false)
    
}


// MARK: - Module Input
extension NotesListPresenter: NotesListModuleInput {
   
    
}


// MARK: - Interactor Output
extension NotesListPresenter: NotesListInteractorOutput {
    
}


// MARK: - View Output
extension NotesListPresenter: NotesListViewOutput {
    
    func didTriggerViewReadyEvent() {
        let vm = NoteViewModel(title: "Text note asdasdadad adasd asd asd asd asd asdas ", dateString: "22.22.2022", isSelected: false, isEditing: false)
        let vm1 = NoteViewModel(title: "Text note", dateString: "22.22.2022", isSelected: false, isEditing: false)
        let vm2 = NoteViewModel(title: "Text note Text note asdasdadad adasd asd asd asd asd asdas  Text note asdasdadad adasd asd asd asd asd asdas Text note asdasdadad adasd asd asd asd asd asdas ", dateString: "22.22.2022", isSelected: false, isEditing: false)

        viewModel.notes.append(vm)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm1)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm1)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm1)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm1)
        viewModel.notes.append(vm)
        viewModel.notes.append(vm2)
        viewModel.notes.append(vm)
        view?.update(with: viewModel)
    }
    
    func didTriggerViewWillAppearEvent() {
        
    }
    
    func didTapAddNoteButton() {
        router?.openNoteModule()
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
            router?.openNoteModule()
        }
        view?.update(with: viewModel)
    }
    
}
