//
//  LockIindicatorView.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

struct LockIindicatorView: View {
    let point: CGPoint
    let isHighlighted: Bool
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .border(isHighlighted ? .green : .red, width: 2)
            .frame(width: 60, height: 60)
            .position(point)
    }
}

#Preview {
    LockIindicatorView(
        point: CGPoint(x: 100, y: 200),
        isHighlighted: true
    )
}

#Preview {
    LockIindicatorView(
        point: CGPoint(x: 300, y: 250),
        isHighlighted: false
    )
}
