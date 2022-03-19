//
//  UserService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import Firebase


final class UserService {
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard
                let result = result,
                error == nil
            else {
                return
            }
            
            
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard
                let result = result,
                error == nil
            else {
                return
            }
        }
    }
}
