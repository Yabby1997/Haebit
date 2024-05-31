//
//  UIFont+Extensions.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UIFont {
    static func systemFont(
        ofSize size: CGFloat,
        weight: UIFont.Weight,
        design: UIFontDescriptor.SystemDesign
    ) -> UIFont {
        let font: UIFont = .systemFont(ofSize: size, weight: weight)
        if let descriptor = font.fontDescriptor.withDesign(design) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return font
        }
    }
}
