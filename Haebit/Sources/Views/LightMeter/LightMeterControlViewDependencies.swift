//
//  LightMeterControlViewDependencies.swift
//  Haebit
//
//  Created by Seunghun on 12/26/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

final class LightMeterControlViewDependencies: ObservableObject {
    let exposureControlDependency: HaebitApertureRingDependencies
    let zoomControlDependency: HaebitApertureRingDependencies
    let shutterButtonDependency: HaebitShutterButtonDependencies
    
    init(
        exposureControlDependency: HaebitApertureRingDependencies,
        zoomControlDependency: HaebitApertureRingDependencies,
        shutterButtonDependency: HaebitShutterButtonDependencies
    ) {
        self.exposureControlDependency = exposureControlDependency
        self.zoomControlDependency = zoomControlDependency
        self.shutterButtonDependency = shutterButtonDependency
    }
}
