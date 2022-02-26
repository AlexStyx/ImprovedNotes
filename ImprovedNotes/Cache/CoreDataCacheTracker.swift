//
//  CoreDataCacheTracker.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/22/22.
//

import Foundation
import CoreData

protocol CoreDataCacheTrackerProtocol: AnyObject {}


protocol CacheTrackerDelegate: AnyObject {
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeItems changeItems: [ChangeItem])
    func cacheTracker(_ cacheTracker: CoreDataCacheTrackerProtocol, didChangeList newList: [NSManagedObject])
}

class CoreDataCacheTracker<T: NSFetchRequestResult>: NSObject, CoreDataCacheTrackerProtocol, NSFetchedResultsControllerDelegate {
    var delegate: CacheTrackerDelegate?
    
    private var controller: NSFetchedResultsController<T>?
    private var changeItems = [ChangeItem]()
    private var context: NSManagedObjectContext
    
    override init() {
        context = CoreDataStack.shared.managedContext
        super.init()
    }
    
    func fetch(with fetchRequest: NSFetchRequest<T>) {
        controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: context,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        
        controller?.delegate = self
        do {
            try controller?.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard let result = controller?.fetchedObjects as? [NSManagedObject] else { return }
        delegate?.cacheTracker(self, didChangeList: result)
    }
    
    func updatePredicate(_ predicate: NSPredicate?) {
        controller?.fetchRequest.predicate = predicate
        do {
            try controller?.performFetch()
            guard let result = controller?.fetchedObjects as? [NSManagedObject] else { return }
            delegate?.cacheTracker(self, didChangeList: result)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let changeItem = ChangeItem(indexPath: indexPath, newIndexPath: newIndexPath, type: type, object: anObject as? NSManagedObject)
        changeItems.append(changeItem)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.cacheTracker(self, didChangeItems: changeItems)
        changeItems.removeAll()
    }
    
}

