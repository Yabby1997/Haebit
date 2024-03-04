//
//  UIImage+Extensions.swift
//  HaebitDev
//
//  Created by Seunghun on 3/4/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        self.init(data: data)
    }
}
