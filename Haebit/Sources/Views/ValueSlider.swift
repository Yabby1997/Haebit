//
//  ValueSlider.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

struct ValueSlider: View {
    let title: String
    let subtitle: String
    let valueRange: ClosedRange<Float>
    @Binding var value: Float
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline)
            }
            .frame(width: 80)
            .foregroundStyle(.white)
            .shadow(radius: 5)
            Slider(value: $value, in: valueRange)
        }
    }
}

#Preview {
    @State var value: Float = 0.25
    return ValueSlider(
        title: "Demo",
        subtitle: "\(value)",
        valueRange: -0.5...0.5,
        value: $value
    )
}
