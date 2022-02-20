//
//  CoreDataStore.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import Foundation
import CoreData


final class CoreDataStore {
    
    static var shared = CoreDataStore()
    
    private let coreDataStack = CoreDataStack(modelName: Constants.CoreData.modelName)
    
    private init () {}
    
    public func saveModes(for class: Any, models: NSManagedObjectContext, shouldRemove: Bool?, removingPredicate: NSPredicate?) {
        
    }
    
//    public func deleteModels(for class: )
}
