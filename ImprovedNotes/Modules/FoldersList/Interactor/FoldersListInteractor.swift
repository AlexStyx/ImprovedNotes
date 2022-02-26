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
    private var folders = [Folder]()
    
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
        guard let folder = folders.first(where: { $0.id == id}) else { return }
        FoldersService.shared.setCurrentFolder(folder)
    }
    
    func addFolder(title: String) {
        FoldersService.shared.addFolder(with: title)
    }
    
    func removeFolder(withId id: UUID) {
        guard let folder = folders.first(where: { $0.id == id}) else { return }
        FoldersService.shared.remove(folder)
    }
    
    func renameFolder(withId id: UUID, newTitle: String) {
        guard let folder = folders.first(where: { $0.id == id}) else { return }
        FoldersService.shared.rename(folder, newTitle: newTitle)
    }
    
    func searchFolders(with term: String) {
        let predicate = FoldersService.shared.searchNotePredicate(with: term)
        cacheTakcer.updatePredicate(predicate)
    }
    
    func stopSeaching() {
        cacheTakcer.updatePredicate(nil)
    }
}


extension FoldersListInteractor: CacheTrackerDelegate {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem]) {
        for change in changeItems {
            guard let folder = change.object as? Folder else { return }
            switch (change.type) {
            case .insert:
                guard let index = change.newIndexPath?.row else { return }
                folders.insert(folder, at: index)
            case .delete:
                guard let index = change.indexPath?.row else { return }
                folders.remove(at: index)
            case .move:
                guard let sourceIndex = change.indexPath?.row,
                      let destinationIndex = change.newIndexPath?.row
                else { return }
                folders.swapAt(sourceIndex, destinationIndex)
            case .update:
                guard let index = change.indexPath?.row else { return }
                folders[index] = folder
            @unknown default:
                return
            }
        }
        output?.performBatchUpdate(changeItems: changeItems)
    }
    
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject]) {
        guard let folders = newList as? [Folder] else { return }
        self.folders = folders
        output?.didChangeList(folders: folders)
    }
    
    
}
