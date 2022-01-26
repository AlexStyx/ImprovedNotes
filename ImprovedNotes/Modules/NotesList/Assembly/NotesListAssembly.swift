//
//  NotesListNotesListAssembly.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

final class NotesListAssembly: NSObject {

    private var view = NotesListViewController()
    private var presenter = NotesListPresenter()
    private var router = NotesListRouter()
    private var interactor = NotesListInteractor()

    // MARK: - Public method
    @objc func assembleModule(moduleOutput: NotesListModuleOutput?,
                              transition: ((NotesListRouterInput) -> Void)?,
                              completion: ((NotesListModuleInput) -> Void)?) {
        
        configureDependenciesWithModuleOutput(moduleOutput: moduleOutput)
        
        view.setupViewReadyBlock {
            self.addChildComponents()
            if let completion = completion {
                completion(self.presenter)
            }
        }
        
        if let transition = transition {
            transition(router)
        }
        
    }
    
    // MARK: - Child components
    private func addChildComponents() {
        // Present child submodules here
    }
    
    // MARK: - Configure dependencies
    private func configureDependenciesWithModuleOutput(moduleOutput: NotesListModuleOutput?) {
        presenter.view = view
        view.output = presenter
        
        presenter.router = router
        router.view = view
        
        presenter.interactor = interactor
        interactor.output = presenter
        
        presenter.moduleOutput = moduleOutput
    }

}
