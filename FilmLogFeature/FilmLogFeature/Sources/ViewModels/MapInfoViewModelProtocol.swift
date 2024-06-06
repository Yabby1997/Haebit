//
//  MapInfoViewModelProtocol.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

@MainActor
protocol MapInfoViewModelProtocol: ObservableObject {
    var coordinate: Coordinate? { get set }
    var locationInfo: String? { get set }
}
