//
//  FolderService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/12/22.
//

import Foundation
import CoreData

class FoldersService {
    static let shared = FoldersService()
    
    private init() {}
    
    public func currentFolder() -> Folder {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Folder.current), true)
        let request = Folder.fetchRequest()
        request.predicate = predicate
        do {
            let result = try CoreDataStack.shared.managedContext.fetch(request)
            guard let currentFolder = result.first else { fatalError("cannot find Current folder") }
            return currentFolder
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    public func allFolders() -> [Folder] {
        do {
            return try CoreDataStack.shared.managedContext.fetch(Folder.fetchRequest())
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    public func addFolder(with title: String) {
        let folder = Folder(context: CoreDataStack.shared.managedContext)
        folder.title = title
        folder.current = true
        folder.id = UUID()
        CoreDataStack.shared.saveContext()
    }
    
    public func setCurrentFolder(_ currentFolder: Folder) {
        let folderBatchUpdateRequest = NSBatchUpdateRequest(entityName: "Folder")
        folderBatchUpdateRequest.propertiesToUpdate = [#keyPath(Folder.current): false]
        folderBatchUpdateRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Folder.current), true)
        folderBatchUpdateRequest.affectedStores = CoreDataStack.shared.managedContext.persistentStoreCoordinator?.persistentStores
        do {
            try CoreDataStack.shared.managedContext.execute(folderBatchUpdateRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        currentFolder.current = true
        CoreDataStack.shared.saveContext()
    }
    
    public func rename(_ folder: Folder, newTitle title: String) {
        folder.title = title
        CoreDataStack.shared.saveContext()
    }
    
    public func remove(_ folder: Folder) {
        CoreDataStack.shared.managedContext.delete(folder)
        CoreDataStack.shared.saveContext()
    }
    
    public func searchNotePredicate(with term: String) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Folder.title), term)
    }
    
}
