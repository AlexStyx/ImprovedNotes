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
        
    }
    
    func didTriggerViewWillAppearEvent() {
        
    }
    
    func didTapAddNoteButton() {
        router?.openNoteModule()
    }
    
    func didTapGoToFoldersButton() {
        router?.openFoldersListModule()
    }
    
}
