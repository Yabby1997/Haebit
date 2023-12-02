//
//  HaebitApp.swift
//  HaebitUI
//
//  Created by Seunghun on 11/15/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

@main
struct HaebitApp: App {
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(viewModel: HaebitLightMeterViewModel())
                .environmentObject(
                    HaebitApertureRingDependencies(
                        feedbackProvidable: DefaultFeedbackProvidable()
                    )
                )
        }
    }
}
