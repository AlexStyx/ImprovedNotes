//
//  UserReuest.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/23/22.
//

import Foundation
import FirebaseDatabase


struct UserRequest: RequestProtocol {
    
    var reference: DatabaseReference
    var action: Action
    var data: BaseRealtimeDatabaseModel?
    var result: Any?
    
    init(reference: DatabaseReference) {
        self.reference = reference
        self.action = .get
    }
    
    init(reference: DatabaseReference, action: Action) {
        self.reference = reference
        self.action = action
    }
    
    init(reference: DatabaseReference, action: Action, data: BaseRealtimeDatabaseModel?) {
        self.reference = reference
        self.action = action
        self.data = data
    }
    
    mutating func handle(_ response: Response) -> Bool {
        guard
            response.error == nil,
            let userData = response.data,
            let user = INUser.model(from: userData)
        else {
            return false
        }
        self.result = user
        return true
    }
}
