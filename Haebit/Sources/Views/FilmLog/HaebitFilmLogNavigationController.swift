//
//  HaebitFilmLogNavigationController.swift
//  HaebitDev
//
//  Created by Seunghun on 4/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

final class HaebitFilmLogNavigationController: UINavigationController {
    private let animator = HaebitNavigationAnimator()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
