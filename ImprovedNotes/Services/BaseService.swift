//
//  BaseService.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/22/22.
//

import Foundation
import FirebaseDatabase

enum UpdateError: Error {
    case noData
}
enum Action {
    case get
    case create
    case update
}

protocol BaseServiceProtocol {
    func perform(_ request: RequestProtocol, completion: ((Any?, Error?) -> ()))
}

extension BaseServiceProtocol {
    
    func perform(_ request: RequestProtocol, completion: ((Any?, Error?) -> ())) {
        
        switch request.action {
    
        case .get:
            var request = request
            request.reference.getData { error, snapshot in
                let response = Response(data: snapshot, error: error)
                let result = request.handle(response)
                if request.handle(response) {
                    completion(request.result, error)
                    return
                }
                completion(result, error)
            }
        case .create:
            request.reference.setValue(request.data?.dataDict)
        case .update:
            guard let dataDict = request.data?.dataDict
            else {
                completion(nil, UpdateError.noData)
                return

            }
            request.reference.updateChildValues(dataDict)
        }
    }
    
    
}
