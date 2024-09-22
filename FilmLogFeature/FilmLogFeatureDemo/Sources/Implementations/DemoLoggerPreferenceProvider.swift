//
//  DemoLoggerPreferenceProvider.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 9/19/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import HaebitCommonModels
import FilmLogFeature
import Foundation

class DemoLoggerPreferenceProvider: LoggerPreferenceProvidable {
    @Published var perforationShape: PerforationShape = .ks
    var perforationShapePublisher: AnyPublisher<HaebitCommonModels.PerforationShape, Never> {
        $perforationShape.eraseToAnyPublisher()
    }
}
