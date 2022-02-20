//
//  FoldersListViewModel.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import UIKit

protocol FoldersListViewModelProtocol {
    func numberOfRows() -> Int
    func viewModelForCell(for indexPath: IndexPath)
}
//
//struct FoldersListViewModel: FoldersListViewModelProtocol {
////    private var notes = [F]()
//}
