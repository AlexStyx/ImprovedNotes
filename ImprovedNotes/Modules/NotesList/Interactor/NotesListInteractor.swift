//
//  NotesListNotesListInteractor.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation
import CoreData

final class NotesListInteractor {
    
    weak var output: NotesListInteractorOutput?
    
    private let cacheTracker = CoreDataCacheTracker<Note>()
    private var currentSortValue: SortValue?
    private var currentFolder: Folder?
    
    init() {
        cacheTracker.delegate = self
    }
    
    // MARK: - Private
    private func sortDescriptors() -> [NSSortDescriptor] {
        guard let currentSortValue = currentSortValue else {
            return [NSSortDescriptor(key: SortValue.allCases.first!.rawValue, ascending: false)]
        }
        
        return [NSSortDescriptor(key: currentSortValue.rawValue, ascending: false)]
    }
    
    private func predicate(searchTerm term: String?) -> NSPredicate? {
        guard let currentFolder = currentFolder else { return nil }
        let folderPredicate = NSPredicate(format: "folder == %@", currentFolder)
        if let term = term {
            let searchPredicate = NSPredicate(format: "%K == %@", #keyPath(Note.title), term)
            return NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, searchPredicate])
        }
        return folderPredicate
    }
}


// MARK: - Interactor Input
extension NotesListInteractor: NotesListInteractorInput {
    func loadData(with sortValue: SortValue?) {
        let request = Note.fetchRequest()
        currentFolder = FoldersService.shared.currentFolder()
        if let sortValue = sortValue {
            currentSortValue = sortValue
        }
        request.predicate = predicate(searchTerm: nil)
        request.sortDescriptors = sortDescriptors()
        cacheTracker.fetch(with: request)
    }
    
    
}

// MARK: - CacheTrackerDelegate
extension NotesListInteractor: CacheTrackerDelegate {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem]) {
        output?.performBatchUpdate(changeItems: changeItems)
    }
    
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject]) {
        guard let notes = newList as? [Note] else { return }
        output?.didChangeList(notes: notes)
    }
    
    
}
