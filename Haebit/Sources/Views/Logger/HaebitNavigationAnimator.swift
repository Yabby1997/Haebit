//
//  HaebitNavigationAnimator.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

protocol HaebitNavigationAnimatorSnapshotProvidable: UIViewController {
    func viewForTransition() -> UIView?
    func regionForTransition() -> CGRect?
}

class HaebitNavigationAnimator: NSObject {
    var isDismissingWithGesture = false
    private var isPresenting = true
    
    private let pushPopDuration: TimeInterval = 0.5
    private let pushPopSpringDamping: CGFloat = 0.8
    
    private let interactionSuccessDuration: TimeInterval = 0.25
    private let interactionCancelDuration: TimeInterval = 0.5
    private let interactionCancelSpringDamping: CGFloat = 0.9
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var baseTargetFrame: CGRect?
    private var pushedTargetFrame: CGRect?
    private var snapshot: UIView?
    
    // MARK: - Internal Methods
    
    func dismissWithGesture(translation: CGPoint, velocity: CGPoint, isEnded: Bool) {
        guard let transitionContext,
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame,
              let base = transitionContext.viewController(forKey: .to)  as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame else { return }
        
        pushedTargetView.isHidden = true
        baseTargetView.isHidden = true
        
        let newCenter = CGPoint(
            x: pushedTargetView.center.x + translation.x,
            y: pushedTargetView.center.y + translation.y
        )
        
        snapshot?.center = newCenter
        let percentage = min((translation.y < .zero ? .zero : translation.y / pushedTargetView.center.y), 1.0)
        pushed.view.alpha = 1 - percentage
        transitionContext.updateInteractiveTransition(percentage)
        
        guard isEnded else { return }
        
        if velocity.y >= 0, newCenter.y > pushedTargetView.center.y {
            UIView.animate(
                withDuration: interactionSuccessDuration,
                delay: .zero,
                options: []
            ) { [weak self] in
                self?.snapshot?.frame = baseTargetFrame
                pushed.view.alpha = .zero
                base.tabBarController?.tabBar.alpha = 1
            } completion: { [weak self] _ in
                pushedTargetView.isHidden = false
                baseTargetView.isHidden = false
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
                self?.snapshot?.removeFromSuperview()
                self?.transitionContext = nil
            }
        } else {
            UIView.animate(
                withDuration: interactionCancelDuration,
                delay: .zero,
                usingSpringWithDamping: interactionCancelSpringDamping,
                initialSpringVelocity: .zero,
                options: []
            ) { [weak self] in
                self?.snapshot?.frame = pushedTargetFrame
                pushed.view.alpha = 1.0
                base.tabBarController?.tabBar.alpha = .zero
            } completion: { [weak self] _ in
                pushedTargetView.isHidden = false
                baseTargetView.isHidden = false
                transitionContext.cancelInteractiveTransition()
                transitionContext.completeTransition(false)
                self?.snapshot?.removeFromSuperview()
                self?.transitionContext = nil
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func animatePushTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let pushed = transitionContext.viewController(forKey: .to) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.regionForTransition(),
              let pushedTargetFrame = pushed.viewForTransition(),
              let base = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame = base.regionForTransition(),
              let snapshot = baseTargetView.snapshotView(afterScreenUpdates: false) else { return }
        
        baseTargetView.isHidden = true
        pushedTargetFrame.isHidden = true
        
        pushed.view.alpha = .zero
        transitionContext.containerView.addSubview(pushed.view)
        
        snapshot.frame = baseTargetFrame
        transitionContext.containerView.addSubview(snapshot)
        
        UIView.animate(
            withDuration: pushPopDuration,
            delay: .zero,
            usingSpringWithDamping: pushPopSpringDamping,
            initialSpringVelocity: .zero,
            options: .transitionCrossDissolve
        ) {
            snapshot.frame = pushedTargetView
            pushed.view.alpha = 1.0
            base.tabBarController?.tabBar.alpha = .zero
        } completion: { _ in
            baseTargetView.isHidden = false
            pushedTargetFrame.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animatePopTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let base = transitionContext.viewController(forKey: .to) as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame = base.regionForTransition(),
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame = pushed.regionForTransition(),
              let snapshot = pushedTargetView.snapshotView(afterScreenUpdates: false) else { return }
        
        pushedTargetView.isHidden = true
        baseTargetView.isHidden = true
        
        snapshot.frame = pushedTargetFrame
        transitionContext.containerView.addSubview(snapshot)
        transitionContext.containerView.insertSubview(base.view, belowSubview: pushed.view)
        
        UIView.animate(
            withDuration: pushPopDuration,
            delay: .zero,
            usingSpringWithDamping: pushPopSpringDamping,
            initialSpringVelocity: .zero,
            options: .transitionCrossDissolve
        ) {
            snapshot.frame = baseTargetFrame
            pushed.view.alpha = .zero
            base.tabBarController?.tabBar.alpha = 1.0
        } completion: { completed in
            pushedTargetView.isHidden = false
            baseTargetView.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

extension HaebitNavigationAnimator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            isPresenting = true
        case .pop:
            isPresenting = false
        default: break
        }
        return self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        isDismissingWithGesture ? self : nil
    }
}

extension HaebitNavigationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        pushPopDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePushTransition(using: transitionContext)
        } else {
            animatePopTransition(using: transitionContext)
        }
    }
}

extension HaebitNavigationAnimator: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let base = transitionContext.viewController(forKey: .to) as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetFrame = base.regionForTransition(),
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame = pushed.regionForTransition(),
              let snapshot = pushedTargetView.snapshotView(afterScreenUpdates: false) else { return }
        
        self.baseTargetFrame = baseTargetFrame
        self.pushedTargetFrame = pushedTargetFrame
        self.snapshot = snapshot
        snapshot.frame = baseTargetFrame
        
        transitionContext.containerView.insertSubview(base.view, belowSubview: pushed.view)
        transitionContext.containerView.addSubview(snapshot)
    }
}
