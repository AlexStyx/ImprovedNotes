//
//  FolderService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/12/22.
//

import Foundation
import CoreData
import UserNotifications

enum FoldersConstants {
    static let sortStep: Int64 = 10
}



final class FoldersService {
    static let shared = FoldersService()
    
    var entityName = "Folder"

    private init() {}
    
    // MARK: - Public
    public func currentFolder() -> Folder? {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(Folder.current), true)
        return CoreDataStore.shared.firstModel(for: Folder.self, predicate: predicate)
    }
    
    public func allFolders() -> [Folder] {
        return CoreDataStore.shared.loadModels(for: Folder.self, predicate: nil)
    }
    
    public func addFolder(with title: String) {
        let folder = Folder(context: CoreDataStack.shared.managedContext)
        let folderId = UUID()
        folder.title = title
        folder.id = folderId
        folder.sort = getSortIndexForLastFolder() + 10
        setCurrentFolder(id: folderId)
        CoreDataStack.shared.saveContext()
    }
    
    public func setCurrentFolder(id folderId: UUID) {
        guard folderId != currentFolder()?.id else { return }
        
        let selectPredicate = NSPredicate(format: "id == %@", folderId.uuidString)
        let deselectPredicate = NSPredicate(format: "id != %@", folderId.uuidString)
        
        let selectCacheUpdate = CacheUpdate(propertiesToUpdate: [#keyPath(Folder.current): true], predicate: selectPredicate)
        let deselectCacheUpdate = CacheUpdate(propertiesToUpdate: [#keyPath(Folder.current): false], predicate: deselectPredicate)
        
        CoreDataStore.shared.update([deselectCacheUpdate, selectCacheUpdate], for: Folder.self)
    
        NotificationCenter.default.post(name: NSNotification.Name(DidSelectCurrentFolderNotification), object: nil)

    }
    
    
    public func renameFolder(with id: UUID, newTitle title: String) {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        CoreDataStore.shared.update([#keyPath(Folder.title): title], for: Folder.self, predicate: predicate)

    }
    
    public func removeFolder(with id: UUID) {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        CoreDataStore.shared.deleteModels(for: Folder.self, predicate: predicate)
    }
    
    public func searchNotePredicate(with term: String) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Folder.title), term)
    }
    
    public func changeSortIndex(folderId: UUID, before: UUID?, after: UUID?) {
        var newSort: Int64
        let beforeSort = getSortForFolder(with: before)
        let afterSort = getSortForFolder(with: after)
        switch (before, after) {
        case (nil, after):
            newSort = afterSort! / 2
        case (before, nil):
            newSort = beforeSort! + FoldersConstants.sortStep / 2
        case (before, after):
            newSort = (beforeSort! + afterSort!) / 2
            break
        default:
            fatalError("")
        }
                
        var startSortUpdatesIfNeededSortIndex: Int64?
        
        if newSort == afterSort {
            startSortUpdatesIfNeededSortIndex = afterSort
        } else if newSort == beforeSort {
            startSortUpdatesIfNeededSortIndex = beforeSort
        }
        
        if let startSortUpdatesIfNeededSortIndex = startSortUpdatesIfNeededSortIndex {
            updateSortIndexesForFolders(startingFrom: startSortUpdatesIfNeededSortIndex)
        }
        
        let predicate = NSPredicate(format: "id == %@", folderId.uuidString)
        CoreDataStore.shared.update([#keyPath(Folder.sort): newSort], for: Folder.self, predicate: predicate)
    }
    
    // MARK: - Private

    private func updateSortIndexesForFolders(startingFrom sort: Int64) {
        let predicate = NSPredicate(format: "%K > %d", #keyPath(Folder.sort), sort)
        let folders = CoreDataStore.shared.loadModels(for: Folder.self, predicate: predicate)
        for folder in folders {
            folder.sort += FoldersConstants.sortStep
        }
        CoreDataStack.shared.saveContext()
    }
    
    private func getSortForFolder(with id: UUID?) -> Int64? {
        guard let id = id else { return nil }
        let predicate = NSPredicate(format: "%id == %@", id.uuidString)
        let fetchProperties = [Folder.Properties.sort.rawValue]
        return CoreDataStore.shared.loadTheOnlyProperties(fetchProperties, for: Folder.self, predicate: predicate)[Folder.Properties.sort.rawValue] as? Int64
    }
    
    private func getSortIndexForLastFolder() -> Int64 {
        let sortProperty = Folder.Properties.sort.rawValue
        return CoreDataStore.shared.loadTheOnlyProperties([sortProperty], for: Folder.self, predicate: nil, sortValue: sortProperty, ascending: false, fetchLimit: 1)[sortProperty] as? Int64 ?? 0
    }
}
