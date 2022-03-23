//
//  RealtimeDatabaseService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import FirebaseDatabase
import CoreData

enum ReferenceType {
    case user(id: String)
}

final class FirebaseRequestFactory {
    
    static var reference = Database.database().reference()
   
    static func reference(for type: ReferenceType) -> DatabaseReference {
        switch type {
        case .user(let id):
            return reference.child("users").child(id)
        }
    }
    
    static func getUserRequest(with id: String) -> RequestProtocol {
        let request = UserRequest(reference: FirebaseRequestFactory.reference(for: .user(id: id)))
        return request
    }
    
    static func addUserRequest(_ user: INUser) -> RequestProtocol {
        let
    }
 }


