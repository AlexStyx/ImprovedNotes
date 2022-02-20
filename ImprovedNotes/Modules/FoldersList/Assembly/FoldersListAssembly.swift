//
//  FoldersListFoldersListAssembly.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation
import SideMenu

final class FoldersListAssembly: NSObject {

    private var view = FoldersListViewController()
    private var presenter = FoldersListPresenter()
    private var router = FoldersListRouter()
    private var interactor = FoldersListInteractor()

    // MARK: - Public method
    @objc func assembleModule(moduleOutput: FoldersListModuleOutput?,
                              transition: ((FoldersListRouterInput) -> Void)?,
                              completion: ((FoldersListModuleInput) -> Void)?) {
        
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
    private func configureDependenciesWithModuleOutput(moduleOutput: FoldersListModuleOutput?) {
        
        let menu = SideMenuNavigationController(rootViewController: view)
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.width / 1.5
        SideMenuManager.default.leftMenuNavigationController = menu
        
        presenter.view = view
        view.output = presenter
        
        presenter.router = router
        router.view = view
        
        presenter.interactor = interactor
        interactor.output = presenter
        
        presenter.moduleOutput = moduleOutput
    }

}
