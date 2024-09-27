//
//  HaebitOtherConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitOtherConfigSection: View {
    var body: some View {
        Section {
            NavigationLink {
                Text("OpenSource")
            } label: {
                Text("OpenSource")
                    .font(.system(size: 16, weight: .semibold))
            }
            NavigationLink {
                Text("AppStore")
            } label: {
                Text("Review on AppStore")
                    .font(.system(size: 16, weight: .semibold))
            }
            NavigationLink {
                Text("Buy me a film")
            } label: {
                Text("Buy me a film")
                    .font(.system(size: 16, weight: .semibold))
            }
            NavigationLink {
                Text("Contact")
            } label: {
                Text("Contact")
                    .font(.system(size: 16, weight: .semibold))
            }
            HStack {
                Text("App Version")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("1.4.0")
                    .font(.system(size: 14, design: .monospaced))
            }
        } header: {
            HStack {
                Image(systemName: "text.bubble")
                Text("Other")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}

#Preview {
    HaebitOtherConfigSection()
}
