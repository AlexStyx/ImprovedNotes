//
//  AuthViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation

final class AuthViewModel: ObservableObject {
    
    @Published var loginSunness = true
    
    var coordinator: AuthCoordinatorProtocol!
    
    func registerButtonTapped(email: String?, password: String?) {
        coordinator.goToNotesList()
    }
    
    func signInTapped(email: String?, password: String?) {
        coordinator.goToNotesList()
    }
}
