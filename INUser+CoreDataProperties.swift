//
//  INUser+CoreDataProperties.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//
//

import Foundation
import CoreData


extension INUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<INUser> {
        return NSFetchRequest<INUser>(entityName: "INUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var login: String?
    @NSManaged public var reference: String?

}

extension INUser : Identifiable {

}
