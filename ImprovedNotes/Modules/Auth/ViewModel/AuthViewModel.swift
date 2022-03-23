//
//  AuthViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation


enum AuthViewState {
    case login
    case register
    
    mutating func toggle() {
        self = self == .login ? .register : .login
    }
}


final class AuthViewModel: ObservableObject {
    
    @Published var loginSuccss = true
    
    var coordinator: AuthCoordinatorProtocol!
    
    func registerButtonTapped(email: String?, password: String?, name: String) {
        guard
            let email = email,
            let password = password
        else {
            loginSuccss = false
            return
        }
        
        UserService.shared.registerUser(email: email, password: password, name: name) { [weak self] success in
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccss = result
            if strongSelf.loginSuccss {
                strongSelf.coordinator.goToNotesList()
            }
        }
    }
}
