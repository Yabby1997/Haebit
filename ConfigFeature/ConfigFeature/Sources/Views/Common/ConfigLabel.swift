//
//  ConfigLabel.swift
//  ConfigFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

struct ConfigLabel: View {
    let title: LocalizedStringResource
    let value: String
    let isNew: Bool
    
    init(title: LocalizedStringResource, value: String, isNew: Bool = false) {
        self.title = title
        self.value = value
        self.isNew = isNew
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            if isNew {
                Text("NEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.yellow)
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, design: .monospaced))
        }
    }
}
