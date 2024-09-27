//
//  HaebitControlConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitControlConfigSection: View {
    var body: some View {
        Section {
            NavigationLink {
                Text("Aperture")
            } label: {
                HStack {
                    Text("Aperture")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("12 items")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("Shutter Speed")
            } label: {
                HStack {
                    Text("Shutter Speed")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("8 items")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("ISO")
            } label: {
                HStack {
                    Text("ISO")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("400")
                    }
                    .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("Focal Length")
            } label: {
                HStack {
                    Text("Focal Length")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("50mm")
                    }
                    .font(.system(size: 14, design: .monospaced))
                }
            }
        } header: {
            HStack {
                Image(systemName: "f.cursive")
                Text("Control")
            }
            .font(.system(size: 14, weight: .bold))
        } footer: {
            Text("At least a type of exposure related value should have more than two items.")
        }
    }
}

#Preview {
    HaebitControlConfigSection()
}
