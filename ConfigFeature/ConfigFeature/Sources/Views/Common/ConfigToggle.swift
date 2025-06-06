//
//  ConfigToggle.swift
//  ConfigFeature
//
//  Created by Seunghun on 6/4/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

struct ConfigToggle: View {
    let title: LocalizedStringResource
    @Binding var isNew: Bool
    @Binding var isOn: Bool
    
    init(
        title: LocalizedStringResource,
        isNew: Binding<Bool> = .constant(false),
        isOn: Binding<Bool>
    ) {
        self.title = title
        self._isNew = isNew
        self._isOn = isOn
    }
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                if isNew {
                    Text("NEW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.yellow)
                        .opacity(isNew ? 1.0 : .zero)
                }
            }
            .animation(.easeInOut, value: isNew)
        }
        .tint(.yellow)
        .onChange(of: isOn) { _ in
            isNew = false
        }
    }
}
