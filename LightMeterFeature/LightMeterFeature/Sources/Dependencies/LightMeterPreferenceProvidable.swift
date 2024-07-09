//
//  LightMeterPreferenceProvidable.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import HaebitCommonModels
import Foundation

public protocol LightMeterPreferenceProvidable: AnyObject {
    var apertureValues: [ApertureValue] { get }
    var shutterSpeedValues: [ShutterSpeedValue] { get }
    var isoValues: [IsoValue] { get }
    func focalLengthValues(under maxZoomFactor: CGFloat) -> [FocalLengthValue]
}
