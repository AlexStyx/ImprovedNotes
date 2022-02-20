//
//  CoreDatastack.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    public lazy var managedContext: NSManagedObjectContext = {
        storeContainer.viewContext
    }()
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
        }
        
        return container
    }()
    
    
    private func saveContext() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
