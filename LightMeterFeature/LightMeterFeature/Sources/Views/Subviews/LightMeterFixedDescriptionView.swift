//
//  LightMeterConstantView.swift
//  LightMeterFeature
//
//  Created by Seunghun on 9/15/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct LightMeterFixedDescriptionView: View {
    let description: String
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image.lockFill
                Text(description)
            }
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundStyle(.white)
            Spacer()
        }
        .shadow(radius: 10)
        .allowsHitTesting(false)
    }
}
