//
//  NoteNotePresenter.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

final class NotePresenter: NSObject {
    
    weak var view: NoteViewInput?
    var interactor: NoteInteractorInput?
    var router: NoteRouterInput?
    weak var moduleOutput: NoteModuleOutput?
    
    // MARK: - Private
    
    private func closeModule() {
        DispatchQueue.main.async { [weak self] in
            self?.router?.closeModule()
        }
    }
    
}


// MARK: - Module Input
extension NotePresenter: NoteModuleInput {
 
}


// MARK: - Interactor Output
extension NotePresenter: NoteInteractorOutput {
    
}


// MARK: - View Output
extension NotePresenter: NoteViewOutput {
    
    func didTriggerViewReadyEvent() {
        
    }
    
    func didTriggerViewWillAppearEvent() {
        
    }
    
    func didTapDismissButton() {
        closeModule()
    }
    
}
