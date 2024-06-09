//
//  Film.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public struct Film: Hashable, Sendable {
    public let id: UUID
    public let date: Date
    public let coordinate: Coordinate?
    public let image: URL
    public let focalLength: FocalLengthValue
    public let iso: IsoValue
    public let shutterSpeed: ShutterSpeedValue
    public let aperture: ApertureValue
    public let memo: String
    
    public func hash(into hasher: inout Hasher) {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
