//
//  CustomToNoteTransition.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/27/22.
//

import UIKit


final class NoteTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting = false
    
    private var duration: TimeInterval = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard
            let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toView = transitionContext.viewController(forKey: .to)?.view
        else {
            return
        }
        
        containerView.addSubview(toView)
        
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
      
      UIView.animate(
        withDuration: duration,
        delay:0.0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.2,
        animations: {
          toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
          transitionContext.completeTransition(true)
      })
    }
    
}
