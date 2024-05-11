//
//  MockLogView.swift
//  HaebitLightMeter
//
//  Created by Seunghun on 5/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct MockLogView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("This is placeholder for log view.\nTap here to dismiss.")
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
        }
        .onTapGesture {
            dismiss()
        }
    }
}

#Preview {
    MockLogView()
}
