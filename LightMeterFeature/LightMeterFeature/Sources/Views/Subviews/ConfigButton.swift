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
                Image.gearshape2fill
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            }
            .frame(width: 50, height: 50)
            Spacer()
        }
    }
}
