//
//  BulletedText.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct BulletedText: View {
    private let key: LocalizedStringKey
    
    init(_ key: LocalizedStringKey) {
        self.key = key
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Text("•").fontWeight(.bold)
            Text(key)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}
