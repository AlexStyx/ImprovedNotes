//
//  UserService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import FirebaseAuth
import CoreData


final class UserService {
    
    static let shared = UserService()
    
    private init() {}
    
    func registerUser(email: String, password: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard
                let result = result,
                error == nil
            else {
                return
            }
            
        }
    }
    
    func login(email: String, password: String, completiot: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard
                let result = result,
                error == nil
            else {
                return
            }
            let firebaseUser = result.user
        }
    }
    
    
    private func save(_ user: User) {
        let user = INUser.user(from: user)
        CoreDataStack.shared.saveContext()
    }
}
