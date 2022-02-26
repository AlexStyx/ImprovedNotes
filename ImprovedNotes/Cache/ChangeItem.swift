//
//  ChangeItem.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/23/22.
//

import Foundation
import CoreData


struct ChangeItem {
    let indexPath: IndexPath?
    let newIndexPath: IndexPath?
    let type: NSFetchedResultsChangeType
    let object: NSManagedObject?
}
