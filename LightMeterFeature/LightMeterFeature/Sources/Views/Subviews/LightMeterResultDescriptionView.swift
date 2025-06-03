//
//  LightMeterResultDescriptionView.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

struct LightMeterResultDescriptionView: View {
    let resultDescription: String
    let exposureValue: Float
    let isLocked: Bool

    var body: some View {
        VStack {
            Text(resultDescription.replacingOccurrences(of: "⁄", with: "⁄ "))
                .font(.system(size: 50, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .animation(.easeInOut, value: resultDescription)
            Text(String(format: "EV %.2f", exposureValue))
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundStyle(isLocked ? .yellow : .white)
                .animation(.easeInOut, value: exposureValue)
                .animation(.easeInOut, value: isLocked)
        }
        .frame(maxWidth: .infinity)
        .contentTransition(.numericText())
        .shadow(radius: 10)
        .allowsHitTesting(false)
    }
}
