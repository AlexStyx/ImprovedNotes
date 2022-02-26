//
//  ContentViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/30/22.
//

import Foundation

enum ContentType {
    case text
}

struct ContentViewModel {
    var id: UUID
    var type: ContentType
    var data: Any?
}

extension ContentViewModel: Hashable {
    static func == (lhs: ContentViewModel, rhs: ContentViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
