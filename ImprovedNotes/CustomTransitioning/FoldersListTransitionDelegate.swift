//
//  FoldersListTransitionDelegate.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/23/22.
//

import UIKit

final class FoldersListTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var folderListTransition = FoldersListTranistion(duration: 0.5)

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        folderListTransition.isPresenting = false
        return folderListTransition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        folderListTransition.isPresenting = true
        return folderListTransition
    }
}
