//
//  Note+CoreDataProperties.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/12/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var dateChanged: Date?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateSeen: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var content: NSOrderedSet?
    @NSManaged public var folder: Folder?

}

// MARK: Generated accessors for content
extension Note {

    @objc(insertObject:inContentAtIndex:)
    @NSManaged public func insertIntoContent(_ value: ContentItem, at idx: Int)

    @objc(removeObjectFromContentAtIndex:)
    @NSManaged public func removeFromContent(at idx: Int)

    @objc(insertContent:atIndexes:)
    @NSManaged public func insertIntoContent(_ values: [ContentItem], at indexes: NSIndexSet)

    @objc(removeContentAtIndexes:)
    @NSManaged public func removeFromContent(at indexes: NSIndexSet)

    @objc(replaceObjectInContentAtIndex:withObject:)
    @NSManaged public func replaceContent(at idx: Int, with value: ContentItem)

    @objc(replaceContentAtIndexes:withContent:)
    @NSManaged public func replaceContent(at indexes: NSIndexSet, with values: [ContentItem])

    @objc(addContentObject:)
    @NSManaged public func addToContent(_ value: ContentItem)

    @objc(removeContentObject:)
    @NSManaged public func removeFromContent(_ value: ContentItem)

    @objc(addContent:)
    @NSManaged public func addToContent(_ values: NSOrderedSet)

    @objc(removeContent:)
    @NSManaged public func removeFromContent(_ values: NSOrderedSet)

}

extension Note : Identifiable {

}
