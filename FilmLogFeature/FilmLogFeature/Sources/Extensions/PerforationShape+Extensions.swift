//
//  PerforationShape+Extensions.swift
//  FilmLogFeature
//
//  Created by Seunghun on 9/19/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels
import UIKit

extension PerforationShape {
    var frameImage: UIImage {
        switch self {
        case .bh: return FilmLogFeatureAsset.frameBH.image
        case .ks: return FilmLogFeatureAsset.frameKS.image
        }
    }
}
