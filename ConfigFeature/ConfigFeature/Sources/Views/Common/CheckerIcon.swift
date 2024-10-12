//
//  CheckerIcon.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct CheckerIcon: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray, lineWidth: 1)
                .frame(width: 26, height: 26)
                .foregroundStyle(.clear)
            if isChecked {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.yellow)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.black)
            }
        }
        .frame(width: 28, height: 28)
        .animation(.easeInOut(duration: 0.2), value: isChecked)
    }
}

#Preview {
    CheckerIcon(isChecked: .constant(true))
}

#Preview {
    CheckerIcon(isChecked: .constant(false))
}
