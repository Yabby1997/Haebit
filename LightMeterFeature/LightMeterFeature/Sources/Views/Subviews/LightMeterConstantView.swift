//
//  LightMeterConstantView.swift
//  LightMeterFeature
//
//  Created by Seunghun on 9/15/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct LightMeterConstantView: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(viewModel.constantsDescription)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                Spacer()
            }
            Spacer()
        }
        .shadow(radius: 10)
        .padding(8)
    }
}
