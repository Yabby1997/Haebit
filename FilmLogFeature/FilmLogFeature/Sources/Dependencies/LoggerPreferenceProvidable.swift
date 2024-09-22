//
//  LoggerDependencyProvidable.swift
//  FilmLogFeature
//
//  Created by Seunghun on 9/19/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels

public protocol LoggerPreferenceProvidable: AnyObject {
    var perforationShapePublisher: AnyPublisher<PerforationShape, Never> { get }
}
