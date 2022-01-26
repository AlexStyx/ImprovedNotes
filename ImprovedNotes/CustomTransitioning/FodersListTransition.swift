//
//  FodersListTransition.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/23/22.
//

import UIKit

final class FoldersListTranistion: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting = false
    private var duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containverView = transitionContext.containerView
        guard
            let fromView = transitionContext.viewController(forKey: .from)?.view,
            let toView = transitionContext.viewController(forKey: .to)?.view
        else {
            return
        }
        
        let presentingView = isPresenting ? toView : fromView
        containverView.addSubview(presentingView)
        
        let size = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height)

        let fromRect = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)
        let toRect = CGRect(origin: CGPoint.zero, size: size)
        
        presentingView.frame = isPresenting ? fromRect : toRect
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) { [unowned self] in
            presentingView.frame = self.isPresenting ? toRect : fromRect
        } completion: { [unowned self] isFinished in
            if !self.isPresenting {
                presentingView.removeFromSuperview()
            }
            transitionContext.completeTransition(isFinished)
        }
    }
}


