//
//  BaseListInteractor.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/15/22.
//

import CoreData


class BaseListInteractor<T: NSManagedObject> {
    
    private let cacheTracker = CoreDataCacheTracker<T>()
    
    init() {
        cacheTracker.delegate = self
    }
}


extension BaseListInteractor: CacheTrackerDelegate {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem]) {
        
    }
    
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject]) {
        guard let items = newList as? [T] else { return }
        
    }
    

}
