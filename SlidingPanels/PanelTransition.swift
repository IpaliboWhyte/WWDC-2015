//
//  PanelTransition.swift
//  SlidingPanels
//
//  Created by Ipalibo Whyte on 14/11/14.
//  Copyright (c) 2014 Ipalibo Whyte. All rights reserved.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    enum State {
        case None
        case Presenting
        case Dismissing
    }
    
    var state = State.None
    var presentingController: UIViewController!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(transitionContext)
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        if (state == .Dismissing) {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }
        
        // get detail view from view controllers
        let backgroundDetailViewMaybe = (backgroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(self)
        let foregroundDetailViewMaybe = (foregroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(self)

        assert(backgroundDetailViewMaybe != nil, "Cannot find detail view in background view controller")
        assert(foregroundDetailViewMaybe != nil, "Cannot find detail view in foreground view controller")
        
        let backgroundDetailView = backgroundDetailViewMaybe!
        let foregroundDetailView = foregroundDetailViewMaybe!
        
        // add views to container
        containerView.addSubview(backgroundViewController.view)
        
        let wrapperView = UIView(frame: foregroundViewController.view.frame)
        wrapperView.layer.shadowRadius = 5
        wrapperView.layer.shadowOpacity = 0.3
        wrapperView.layer.shadowOffset = CGSizeZero
        wrapperView.addSubview(foregroundViewController.view)
        foregroundViewController.view.clipsToBounds = true

        containerView.addSubview(wrapperView)
        
        // perform animation
        (foregroundViewController as? PanelTransitionViewController)?.panelTransitionWillAnimateTransition?(self, presenting: state == .Presenting, isForeground: true)
        
        backgroundDetailView.hidden = true
        
        let backgroundFrame = containerView.convertRect(backgroundDetailView.frame, fromView: backgroundDetailView.superview)
        let screenBounds = UIScreen.mainScreen().bounds
        let scale = backgroundFrame.width / screenBounds.width
        
        if state == .Presenting {
            wrapperView.transform = CGAffineTransformMakeScale(scale, scale)
            foregroundDetailView.transitionProgress = 1
        }
        else {
            wrapperView.transform = CGAffineTransformIdentity
        }

        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in            
            [self]
            if self.state == .Presenting {
                wrapperView.transform = CGAffineTransformIdentity
                foregroundDetailView.transitionProgress = 0
            }
            else {
                wrapperView.transform = CGAffineTransformMakeScale(scale, scale)
                foregroundDetailView.transitionProgress = 1
            }

        }) { (finished) -> Void in
            backgroundDetailView.hidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingController = presenting
        if presented is PanelTransitionViewController &&
            presenting is PanelTransitionViewController {
                state = .Presenting
                return self
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is PanelTransitionViewController &&
            presentingController is PanelTransitionViewController {
                state = .Dismissing
                return self
        }
        return nil
    }
   
}

@objc
protocol PanelTransitionViewController {
    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView!
    
    optional func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool)
}
