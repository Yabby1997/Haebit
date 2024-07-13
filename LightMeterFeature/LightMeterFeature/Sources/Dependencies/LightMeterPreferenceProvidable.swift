//
//  LightMeterPreferenceProvidable.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels

public protocol LightMeterPreferenceProvidable: AnyObject {
    var apertureValues: AnyPublisher<[ApertureValue], Never> { get }
    var shutterSpeedValues: AnyPublisher<[ShutterSpeedValue], Never> { get }
    var isoValues: AnyPublisher<[IsoValue], Never> { get }
    var focalLengthValues: AnyPublisher<[FocalLengthValue], Never> { get }
}
