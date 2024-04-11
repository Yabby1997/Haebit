//
//  UITabBarController+Extensions.swift
//  HaebitDev
//
//  Created by Seunghun on 4/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UITabBarController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self else { return }
            tabBar.alpha = hidden ? .zero : 1.0
            tabBar.frame.origin = CGPoint(
                x: .zero,
                y: UIScreen.main.bounds.maxY - (hidden ? .zero : tabBar.frame.height)
            )
        }
    }
}
