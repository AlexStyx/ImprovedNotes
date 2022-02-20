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
    var data: Data?
}

extension ContentViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
