//
//  Sort.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/23/22.
//

import Foundation

enum SortValue: String, CaseIterable {
    static var allCases = [SortValue.dateSeen, .dateChanged, .dateCreated]
    
    case dateCreated
    case dateSeen
    case dateChanged
}
