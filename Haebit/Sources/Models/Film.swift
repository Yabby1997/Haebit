//
//  Log.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

struct Film: Hashable {
    let id: UUID
    let date: Date
    let coordinate: Coordinate?
    let image: URL
    let focalLength: FocalLengthValue
    let iso: IsoValue
    let shutterSpeed: ShutterSpeedValue
    let aperture: ApertureValue
    let memo: String
    
    public func hash(into hasher: inout Hasher) {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    static func == (lhs: Film, rhs: Film) -> Bool {
        lhs.id == rhs.id
    }
}
