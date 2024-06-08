//
//  File.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/7/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

struct MapSearchResult: Hashable {
    let name: String
    let address: String
    let coordinate: Coordinate
}
