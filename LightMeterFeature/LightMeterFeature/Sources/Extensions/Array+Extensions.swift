//
//  Array+Extensions.swift
//  LightMeterFeature
//
//  Created by Seunghun on 10/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

extension Array where Element == ShutterSpeedValue {
    func nearest(to shutterSpeed: ShutterSpeedValue) -> ShutterSpeedValue? {
        nearest(to: shutterSpeed.value)
    }
    
    func nearest(to shutterSpeedValue: Float) -> ShutterSpeedValue? {
        let stopDiffs = map { abs(log2($0.value / shutterSpeedValue)) }
        guard let minStopDiff = stopDiffs.min(),
              let minStopDiffIndex = stopDiffs.firstIndex(of: minStopDiff) else { return nil }
        return self[minStopDiffIndex]
    }
}

extension Array where Element == IsoValue {
    func nearest(to iso: IsoValue) -> IsoValue? {
        nearest(to: Float(iso.value))
    }
    
    func nearest(to isoValue: Float) -> IsoValue? {
        let stopDiffs = map { abs(log2(Float($0.value) / isoValue)) }
        guard let minStopDiff = stopDiffs.min(),
              let minStopDiffIndex = stopDiffs.firstIndex(of: minStopDiff) else { return nil }
        return self[minStopDiffIndex]
    }
}

extension Array where Element == ApertureValue {
    func nearest(to aperture: ApertureValue) -> ApertureValue? {
        nearest(to: aperture.value)
    }
    
    func nearest(to apertureValue: Float) -> ApertureValue? {
        let stopDiffs = map { abs(log2($0.value / apertureValue) * 2) }
        guard let minStopDiff = stopDiffs.min(),
              let minStopDiffIndex = stopDiffs.firstIndex(of: minStopDiff) else { return nil }
        return self[minStopDiffIndex]
    }
}
