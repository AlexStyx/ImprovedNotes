//
//  CustomtoNoteTransitionDelegate.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import UIKit

final class NoteTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var noteTransition = NoteTransition()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        noteTransition.isPresenting = false
        return noteTransition
    }
}
