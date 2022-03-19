//
//  AuthViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation

final class AuthViewModel: ObservableObject {
    
    @Published var loginSuccss = true
    
    var coordinator: AuthCoordinatorProtocol!
    
    func registerButtonTapped(email: String?, password: String?) {
        guard
            let email = email,
            let password = password
        else {
            loginSuccss = false
            return
        }
        
        UserService.shared.registerUser(email: email, password: password) { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.handleAuthResponse(success, error: nil)
        }
    }
    
    func signInTapped(email: String?, password: String?) {
        guard
            let email = email,
            let password = password
        else {
            loginSuccss = false
            return
        }
        UserService.shared.login(email: email, password: password) { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.handleAuthResponse(success, error: nil)
        }
        
    }
    
    private func handleAuthResponse(_ result: Bool?, error: NSError?) {
        guard
            let result = result,
            error == nil
        else {
            return
        }
        loginSuccss = result
        if loginSuccss {
            coordinator.goToNotesList()
        }

    }
}
