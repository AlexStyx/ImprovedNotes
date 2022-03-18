//
//  FoldersListFoldersListInteractor.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import Foundation
import CoreData

final class FoldersListInteractor {
    
    weak var output: FoldersListInteractorOutput?
    
    private let cacheTakcer = CoreDataCacheTracker<Folder>()
    
    init() {
        cacheTakcer.delegate = self
    }
    
}


// MARK: - Interactor Input
extension FoldersListInteractor: FoldersListInteractorInput {
    func loadData() {
        let request = Folder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        cacheTakcer.fetch(with: request)
    }
    
    func didSelectFolder(withId id: UUID) {
        FoldersService.shared.setCurrentFolder(id: id)
    }
    
    func addFolder(title: String) {
        FoldersService.shared.addFolder(with: title)
    }
    
    func removeFolder(withId id: UUID) {
        FoldersService.shared.removeFolder(with: id)
    }
    
    func renameFolder(withId id: UUID, newTitle: String) {
        FoldersService.shared.renameFolder(with: id, newTitle: newTitle)
    }
    
    func searchFolders(with term: String) {
        let predicate = FoldersService.shared.searchNotePredicate(with: term)
        cacheTakcer.updatePredicate(predicate)
    }
    
    func stopSeaching() {
        cacheTakcer.updatePredicate(nil)
    }
    
    func changePositionForFolder(withId id: UUID, before: UUID?, after: UUID?) {
        FoldersService.shared.changeSortIndex(folderId: id, before: before, after: after)
    }
    
}


extension FoldersListInteractor: CacheTrackerDelegate {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem]) {
        output?.performBatchUpdate(changeItems: changeItems)
    }
    
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject]) {
        guard let folders = newList as? [Folder] else { return }
        output?.didChangeList(folders: folders)
    }
    
    
}
