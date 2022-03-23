//
//  INUser+CoreDataClass.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//
//

import Foundation
import CoreData
import FirebaseAuth
import FirebaseDatabase
import SwiftUI

@objc(INUser)
public class INUser: NSManagedObject {

}

extension INUser {
    static func user(from response: User) -> INUser {
        let user = INUser(context: CoreDataStack.shared.managedContext)
        user.id = response.uid
        user.login = response.email
        return user
    }
}
