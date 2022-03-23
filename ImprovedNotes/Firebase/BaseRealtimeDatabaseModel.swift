//
//  BaseRealtimeDatabaseModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import Foundation
import FirebaseDatabase
import CoreData


protocol BaseRealtimeDatabaseModel {
    static func model(from snapshot: DataSnapshot) -> BaseRealtimeDatabaseModel?
    var realtimeDatabaseId: String { get }
    var dataDict: [String: Any] { get }
}

