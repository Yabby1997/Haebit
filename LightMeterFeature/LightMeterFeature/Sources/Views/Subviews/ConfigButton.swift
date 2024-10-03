//
//  ConfigButton.swift
//  LightMeterFeature
//
//  Created by Seunghun on 10/3/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct ConfigButton: View {
    let action: (() -> Void)?
    
    var body: some View {
        HStack {
            Button {
                action?()
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
            .frame(width: 72, height: 72)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
