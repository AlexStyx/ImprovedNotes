//
//  FoldersListFoldersListRouter.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SideMenu

class FoldersListRouter: BaseSwiftRouter {
    override func closeModule() {
        super.closeModule()
        view?.dismiss(animated: true)
    }
}


// MARK: - Router Input
extension FoldersListRouter: FoldersListRouterInput {
    
}
