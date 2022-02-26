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
    
    private func sortDescriptor() -> [NSSortDescriptor] {
        guard let currentSortValue = currentSortValue else {
            return [NSSortDescriptor(key: SortValue.allCases.first!.rawValue, ascending: false)]
        }
        
        return [NSSortDescriptor(key: currentSortValue.rawValue, ascending: false)]
    }
    
    private func predicate() -> NSPredicate? {
        guard let currentFolder = currentFolder else { return nil }
        return NSPredicate(format: "folder == %@", currentFolder)
    }
}


// MARK: - Interactor Input
extension NotesListInteractor: NotesListInteractorInput {
    func loadData(with sortValue: SortValue?) {
        let request = Note.fetchRequest()
        if let sortValue = sortValue {
            currentSortValue = sortValue
        }
        request.predicate = predicate()
        request.sortDescriptors = sortDescriptor()
        cacheTracker.fetch(with: request)
    }
    
    
}

// MARK: - CacheTrackerDelegate
extension NotesListInteractor: CacheTrackerDelegate {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem]) {
        for item in changeItems {
            let note = item.object as? Note
            print(note?.title, item.type)
        }
    }
    
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject]) {
        guard let notes = newList as? [Note] else { return }
        output?.didChangeList(notes: notes)
    }
    
    
}
