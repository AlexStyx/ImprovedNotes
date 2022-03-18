//
//  ApplicationStateManager.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/13/22.
//

import Foundation

class ApplicationStateManager {
    
    var isFolderSortEnabled = false
    
    static let shared = ApplicationStateManager()
    
    private init() {}
}
