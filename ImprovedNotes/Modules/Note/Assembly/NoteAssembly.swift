//
//  NoteNoteAssembly.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation

final class NoteAssembly: NSObject {

    private var view = NoteViewController()
    private var presenter = NotePresenter()
    private var router = NoteRouter()
    private var interactor = NoteInteractor()

    // MARK: - Public method
    @objc func assembleModule(moduleOutput: NoteModuleOutput?,
                              transition: ((NoteRouterInput) -> Void)?,
                              completion: ((NoteModuleInput) -> Void)?) {
        
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
        
    }
    
    // MARK: - Configure dependencies
    private func configureDependenciesWithModuleOutput(moduleOutput: NoteModuleOutput?) {
        presenter.view = view
        view.output = presenter
        view.modalPresentationStyle = .fullScreen
        
        presenter.router = router
        router.view = view
        
        presenter.interactor = interactor
        interactor.output = presenter
        
        presenter.moduleOutput = moduleOutput
    }

}
