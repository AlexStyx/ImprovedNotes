//
//  FolderViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/26/22.
//

import Foundation

struct FolderViewModel {
    let id: UUID
    let name: String
    
    init(folder: Folder) {
        self.name = folder.title ?? ""
        self.id = folder.id ?? UUID()
    }
}

extension FolderViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

