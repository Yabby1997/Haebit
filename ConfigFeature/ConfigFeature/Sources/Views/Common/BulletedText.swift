//
//  BulletedText.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct BulletedText: View {
    private let resource: LocalizedStringResource
    
    init(_ resource: LocalizedStringResource) {
        self.resource = resource
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Text("•").fontWeight(.bold)
            Text(resource)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}
