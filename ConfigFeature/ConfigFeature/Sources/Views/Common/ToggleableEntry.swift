//
//  ToggleableEntry.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct ToggleableEntry: View {
    let title: String
    @Binding var isActive: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(isActive ? .white : .gray)
            Spacer()
            Toggle(isOn: $isActive, label: {})
                .labelsHidden()
        }
    }
}
