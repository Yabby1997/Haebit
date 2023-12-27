//
//  LightMeterStatePersistenceProtocol.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

protocol LightMeterStatePersistenceProtocol: AnyObject {
    var mode: LightMeterMode { get set }
    var aperture: ApertureValue { get set }
    var shutterSpeed: ShutterSpeedValue { get set }
    var iso: IsoValue { get set }
    var focalLength: FocalLengthValue { get set }
}
