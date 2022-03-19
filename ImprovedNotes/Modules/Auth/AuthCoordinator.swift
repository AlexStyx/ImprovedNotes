//
//  AuthCoordinator.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import SwiftUI

protocol AuthCoordinatorProtocol {
    func goToNotesList()
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    
    var view: UIHostingController<AuthView>!
    
    func assemble() {
        let viewModel = AuthViewModel()
        let authView = AuthView(viewModel: viewModel)
        viewModel.coordinator = self
        view = UIHostingController(rootView: authView)
    }
    
    func goToNotesList() {
        let foldersListAssembly = FoldersListAssembly()
        foldersListAssembly.assembleModule(moduleOutput: nil, transition: nil, completion: nil)
        let notesListAssembly = NotesListAssembly()
        notesListAssembly.assembleModule(moduleOutput: nil) { [weak self] router in
            guard let strongSelf = self else { return }
            
            router.openModuleFrom(viewController: strongSelf.view)
        } completion: { _ in }

    }
    
}

