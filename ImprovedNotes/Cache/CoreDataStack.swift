//
//  CoreDatastack.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "CoreDataModel")
    
    public lazy var managedContext: NSManagedObjectContext = {
        storeContainer.viewContext
    }()
    private let modelName: String
    
    private init(modelName: String) {
        self.modelName = modelName
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                            .userDomainMask, true)
        print("path: \(dirPaths[0])")
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
    
    public func saveContext() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
