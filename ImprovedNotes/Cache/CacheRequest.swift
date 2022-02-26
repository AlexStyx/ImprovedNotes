//
//  CacheRequest.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/22/22.
//

import Foundation
import CoreData

struct CacheRequest {
    var entyty: AnyClass
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor]
}
