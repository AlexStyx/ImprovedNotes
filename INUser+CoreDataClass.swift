//
//  INUser+CoreDataClass.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//
//

import Foundation
import CoreData
import Firebase

@objc(INUser)
public class INUser: NSManagedObject {
    static func user(from response: User) {
        let user = INUser(context: CoreDataStack.shared.managedContext)
        user.id = UUID(uuidString: response.uid)
        user.login = user.login
    }
}

