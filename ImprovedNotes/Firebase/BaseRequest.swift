//
//  Request.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/22/22.
//

import Foundation
import FirebaseDatabase
import UIKit


protocol RequestProtocol {
    var reference: DatabaseReference { get }
    var action: Action { get }
    var data: BaseRealtimeDatabaseModel? { get }
    var result: Any? { get }
    mutating func handle(_ response: Response) -> Bool
    init(reference: DatabaseReference, action: Action, data: BaseRealtimeDatabaseModel?)
    init(reference: DatabaseReference, action: Action)
    init(reference: DatabaseReference)
}

extension RequestProtocol {
    mutating func handle(_ response: Response) -> Bool {
        return true
    }
}
