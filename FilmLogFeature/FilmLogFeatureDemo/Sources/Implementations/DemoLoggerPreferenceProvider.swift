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
    var perforationShape: AnyPublisher<HaebitCommonModels.PerforationShape, Never> {
        Just(.ks).eraseToAnyPublisher()
    }
}
