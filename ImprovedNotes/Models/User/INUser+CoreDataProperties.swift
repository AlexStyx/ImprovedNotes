//
//  INUser+CoreDataProperties.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//
//

import Foundation
import CoreData
import FirebaseDatabase


extension INUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<INUser> {
        return NSFetchRequest<INUser>(entityName: "INUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?

}

extension INUser : Identifiable {

}

extension INUser {
    enum Properties: String {
        case id
        case name
        case login
    }
}

extension INUser: BaseRealtimeDatabaseModel {
    
    var dataDict: [String : Any] {
        [Properties.id.rawValue: id!, Properties.name.rawValue: name!, Properties.login.rawValue: login!]
    }
    
    var realtimeDatabaseId: String {
        return id!
    }
    
    static func model(from snapshot: DataSnapshot) -> BaseRealtimeDatabaseModel? {
        let user = INUser(context: CoreDataStack.shared.managedContext)
        user.map(with: snapshot)
        return user
    }
    
    
    
    func map(with snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any] else { return }
        self.name = snapshotValue[Properties.name.rawValue] as? String
        self.login = snapshotValue[Properties.login.rawValue] as? String
        self.id = snapshotValue[Properties.id.rawValue] as? String
    }
}
