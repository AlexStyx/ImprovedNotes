//
//  NotesListNotesListRouter.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SideMenu

final class NotesListRouter: BaseSwiftRouter {
    private var folderListRouter: FoldersListRouterInput?
}


// MARK: - Router Input
extension NotesListRouter: NotesListRouterInput {
    
    func openNoteModule() {
        let noteAssembly = NoteAssembly()
        noteAssembly.assembleModule(moduleOutput: nil) { [weak self] router in
            if let view = self?.view {
                router.openModuleFrom(viewController: view)
            }
        } completion: { _ in }

    }
    
    func openFoldersListModule() {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            view?.present(menu, animated: true)
        }
    }
}
