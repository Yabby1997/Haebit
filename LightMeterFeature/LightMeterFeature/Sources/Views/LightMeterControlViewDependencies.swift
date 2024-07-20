//
//  LightMeterControlViewDependencies.swift
//  Haebit
//
//  Created by Seunghun on 12/26/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

public final class LightMeterControlViewDependencies: ObservableObject {
    let shutterButtonDependency: HaebitShutterButtonDependencies
    
    public init(
        shutterButtonDependency: HaebitShutterButtonDependencies
    ) {
        self.shutterButtonDependency = shutterButtonDependency
    }
}
