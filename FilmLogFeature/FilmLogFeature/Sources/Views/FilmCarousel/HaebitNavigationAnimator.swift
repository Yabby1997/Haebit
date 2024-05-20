//
//  HaebitNavigationAnimator.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

@MainActor
protocol HaebitNavigationAnimatorSnapshotProvidable: UIViewController {
    func viewForTransition() -> UIView?
    func regionForTransition() -> CGRect?
    func blurIntensityForSnapshot() -> CGFloat
}

extension HaebitNavigationAnimatorSnapshotProvidable {
    fileprivate var useBlur: Bool { blurIntensityForSnapshot() != .zero }
}

@MainActor
class HaebitNavigationAnimator: NSObject {
    private var isDismissingWithGesture = false
    private var isPresenting = true
    
    private let pushPopDuration: TimeInterval = 0.5
    private let pushPopSpringDamping: CGFloat = 0.8
    private let blurDuration: TimeInterval = 0.2
    
    private let interactionSuccessDuration: TimeInterval = 0.25
    private let interactionCancelDuration: TimeInterval = 0.5
    private let interactionCancelSpringDamping: CGFloat = 0.9
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var baseTargetFrame: CGRect?
    private var pushedTargetFrame: CGRect?
    private var snapshot: UIView?
    
    private let dismissGestureRecognizer = UIPanGestureRecognizer()
    private weak var navigationController: UINavigationController?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        dismissGestureRecognizer.addTarget(self, action: #selector(interactDismissGestureRecognizer))
    }
    
    // MARK: - Private Methods
    
    @objc private func interactDismissGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began, gesture.velocity(in: gesture.view).y > .zero {
            isDismissingWithGesture = true
            navigationController?.popViewController(animated: true)
        }
        
        guard let transitionContext,
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame,
              let base = transitionContext.viewController(forKey: .to)  as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame else { return }
        
        let translation = gesture.translation(in: pushed.view)
        let velocity = gesture.velocity(in: pushed.view)
        
        let newCenter = CGPoint(
            x: pushedTargetView.center.x + translation.x,
            y: pushedTargetView.center.y + translation.y
        )
        
        let diffWidth = pushedTargetFrame.width - baseTargetFrame.width
        let diffHeight = pushedTargetFrame.height - baseTargetFrame.height
        
        let progress = min((translation.y < .zero ? .zero : translation.y / pushedTargetView.center.y), 1.0)
        pushed.view.alpha = 1 - progress
        transitionContext.updateInteractiveTransition(progress)
        
        snapshot?.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: pushedTargetFrame.width - diffWidth * progress,
                height: pushedTargetFrame.height - diffHeight * progress
            )
        )
        snapshot?.center = newCenter
        
        guard gesture.state == .ended else { return }
        isDismissingWithGesture = false
        
        if velocity.y >= 0, newCenter.y > pushedTargetView.center.y {
            UIView.animate(
                withDuration: interactionSuccessDuration,
                delay: .zero,
                options: .curveEaseIn
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
                options: .curveEaseIn
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
    
    private func animatePushTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let pushed = transitionContext.viewController(forKey: .to) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame = pushed.regionForTransition(),
              let base = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame = base.regionForTransition(),
              let snapshot = baseTargetView.bluredSnapshot(intensity: base.blurIntensityForSnapshot()) else {
            transitionContext.completeTransition(false)
            return
        }
        
        navigationController = pushed.navigationController
        pushed.view.addGestureRecognizer(dismissGestureRecognizer)
        
        baseTargetView.isHidden = true
        pushedTargetView.isHidden = true
        
        pushed.view.alpha = .zero
        transitionContext.containerView.addSubview(pushed.view)
        
        snapshot.frame = baseTargetFrame
        transitionContext.containerView.addSubview(snapshot)
        
        UIView.animate(
            withDuration: pushPopDuration,
            delay: .zero,
            usingSpringWithDamping: pushPopSpringDamping,
            initialSpringVelocity: .zero,
            options: .curveEaseIn
        ) {
            snapshot.frame = pushedTargetFrame
            pushed.view.alpha = 1.0
            base.tabBarController?.tabBar.alpha = .zero
        } completion: { _ in
            baseTargetView.isHidden = false
            pushedTargetView.isHidden = false
            UIView.animate(
                withDuration: base.useBlur ? self.blurDuration : .zero,
                delay: .zero,
                options: .curveEaseInOut
            ) {
                snapshot.alpha = .zero
            } completion: { _ in
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    private func animatePopTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let base = transitionContext.viewController(forKey: .to) as? HaebitNavigationAnimatorSnapshotProvidable,
              let baseTargetView = base.viewForTransition(),
              let baseTargetFrame = base.regionForTransition(),
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame = pushed.regionForTransition(),
              let snapshot = pushedTargetView.bluredSnapshot(intensity: pushed.blurIntensityForSnapshot()) else {
            transitionContext.completeTransition(false)
            return
        }
        
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
            options: .curveEaseIn
        ) {
            snapshot.frame = baseTargetFrame
            pushed.view.alpha = .zero
            base.tabBarController?.tabBar.alpha = 1.0
        } completion: { completed in
            pushedTargetView.isHidden = false
            baseTargetView.isHidden = false
            UIView.animate(
                withDuration: pushed.useBlur ? self.blurDuration: .zero,
                delay: .zero,
                options: .curveEaseInOut
            ) {
                snapshot.alpha = .zero
            } completion: { _ in
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
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
              let baseTargetView = base.viewForTransition(),
              let pushed = transitionContext.viewController(forKey: .from) as? HaebitNavigationAnimatorSnapshotProvidable,
              let pushedTargetView = pushed.viewForTransition(),
              let pushedTargetFrame = pushed.regionForTransition(),
              let snapshot = pushedTargetView.snapshotView(afterScreenUpdates: false) else { return }
        
        baseTargetView.isHidden = true
        pushedTargetView.isHidden = true

        self.baseTargetFrame = baseTargetFrame
        self.pushedTargetFrame = pushedTargetFrame
        self.snapshot = snapshot
        snapshot.frame = pushedTargetFrame
        
        transitionContext.containerView.insertSubview(base.view, belowSubview: pushed.view)
        transitionContext.containerView.addSubview(snapshot)
    }
}

extension UIView {
    fileprivate func bluredSnapshot(intensity: CGFloat) -> UIView? {
        let snapshot = snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: intensity)
        snapshot?.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { $0.edges.equalToSuperview() }
        snapshot?.layoutIfNeeded()
        return snapshot?.snapshotView(afterScreenUpdates: true)
    }
}

fileprivate class CustomIntensityVisualEffectView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { self.effect = effect }
        animator.fractionComplete = intensity
        animator.pausesOnCompletion = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
