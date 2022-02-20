//
//  ContentItem+CoreDataProperties.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/12/22.
//
//

import Foundation
import CoreData


extension ContentItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentItem> {
        return NSFetchRequest<ContentItem>(entityName: "ContentItem")
    }

    @NSManaged public var data: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var type: Int16
    @NSManaged public var note: Note?

}

extension ContentItem : Identifiable {

}
