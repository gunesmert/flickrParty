//
//  BaseNavigationController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit

class SimpleNavigationAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationControllerOperation?
    
    override init() {
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromView = fromVC?.view
        let toView = toVC?.view
        
        let endFrame = transitionContext.initialFrameForViewController(fromVC!)
        
        if operation == UINavigationControllerOperation.Push {
            transitionContext.containerView()?.addSubview(fromView!)
            transitionContext.containerView()?.addSubview(toView!)
            
            var startFrame = endFrame
            var finalFrame = endFrame
            
            startFrame.origin.x += CGRectGetWidth(endFrame)
            finalFrame.origin.x -= CGRectGetWidth(endFrame)
            
            fromView?.frame = endFrame
            toView?.frame = startFrame
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: { () -> Void in
                    toView?.frame = endFrame
                    fromView?.frame = finalFrame
                }, completion: { (finished) -> Void in
                    fromView?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        } else {
            transitionContext.containerView()?.addSubview(fromView!)
            transitionContext.containerView()?.addSubview(toView!)
            
            var startFrame = endFrame
            var finalFrame = endFrame
            
            startFrame.origin.x -= CGRectGetWidth(endFrame)
            finalFrame.origin.x += CGRectGetWidth(endFrame)
            
            fromView?.frame = endFrame
            toView?.frame = startFrame
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    toView?.frame = endFrame
                    fromView?.frame = finalFrame
                }, completion: { (finished) -> Void in
                    fromView?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}

class BaseNavigationController : UINavigationController, UINavigationControllerDelegate {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.mediumFont(withSize: 16.0),
            NSForegroundColorAttributeName: UIColor.lightGrayTextColor()]
        
        self.delegate = self
    }
    
    // MARK: - UINavigationController
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            let animator = SimpleNavigationAnimator()
            
            animator.operation = operation
            
            return animator
    }
}
