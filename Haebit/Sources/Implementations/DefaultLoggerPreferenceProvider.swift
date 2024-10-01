//
//  DefaultLoggerPreferenceProvider.swift
//  HaebitDev
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import FilmLogFeature
import HaebitCommonModels

final class DefaultLoggerPreferenceProvider: LoggerPreferenceProvidable {
    var perforationShapePublisher: AnyPublisher<HaebitCommonModels.PerforationShape, Never> {
        Just(.ks).eraseToAnyPublisher()
    }
}
