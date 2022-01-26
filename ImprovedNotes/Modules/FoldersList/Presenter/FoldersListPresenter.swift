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
    
}


// MARK: - Module Input
extension FoldersListPresenter: FoldersListModuleInput {
    
}


// MARK: - Interactor Output
extension FoldersListPresenter: FoldersListInteractorOutput {
    
}


// MARK: - View Output
extension FoldersListPresenter: FoldersListViewOutput {
    
    func didTriggerViewReadyEvent() {
        
    }
    
    func didTriggerViewWillAppearEvent() {
        
    }
    
}
