//
//  UserService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import FirebaseAuth
import CoreData
import CoreMedia


final class UserService: BaseServiceProtocol {
    
    static let shared = UserService()
    
    private init() {}
    
    func registerUser(email: String, password: String, name: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard
                let strongSelf = self,
                let result = result,
                error == nil
            else {
                completion(false)
                return
            }
            let user = INUser.user(from: result.user)
            user.name = name
            strongSelf.add(user)
            CoreDataStack.shared.saveContext()
            completion(true)
        }
    }
    
    
    func login(email: String, password: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard
                let strongSelf = self,
                let result = result,
                error == nil
            else {
                completion(false)
                return
            }
            let userId = result.user.uid
            strongSelf.loadUser(id: userId)
            completion(true)
        }
    }
    
    
    private func loadUser(id: String) {
        let request = FirebaseRequestFactory.getUserRequest(with: id)
        perform(request) { user, error in
            guard
                let user = user as? INUser,
                error == nil
            else {
                return
            }
            CoreDataStack.shared.saveContext()
        }
    }
    
    
    private func add(_ user: INUser) {
        let request = FirebaseRequestFactory.addUserRequest(user)
        perform(request) { _, _ in }
    }
    
}
