//
//  UINavigationController+Extensions.swift
//  HaebitDev
//
//  Created by Seunghun on 5/5/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UINavigationController {
    enum TitlePosition {
        case center
        case left
        case custom(offset: CGFloat)
        
        fileprivate var horizontalOffset: CGFloat {
            switch self {
            case .center: return .zero
            case .left: return -1.0 * .greatestFiniteMagnitude
            case let .custom(offset): return offset
            }
        }
    }
    
    func setTitlePosition(_ position: TitlePosition) {
        let offset = UIOffset(horizontal: position.horizontalOffset, vertical: .zero)
        navigationBar.standardAppearance.titlePositionAdjustment = offset
        navigationBar.scrollEdgeAppearance?.titlePositionAdjustment = offset
        navigationBar.compactAppearance?.titlePositionAdjustment = offset
    }
}
