//
//  HaebitFeedbackConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitFeedbackConfigSection: View {
    var body: some View {
        Section {
            NavigationLink {
                Text("Aperture Ring")
            } label: {
                HStack {
                    Text("Aperture Ring")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("Rigid")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("Shutter Speed Dial")
            } label: {
                HStack {
                    Text("Shutter Speed Dial")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("Heavy")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("ISO Dial")
            } label: {
                HStack {
                    Text("ISO Dial")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("Heavy")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                Text("Focal Length Ring")
            } label: {
                HStack {
                    Text("Focal Length Ring")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("Soft")
                        .font(.system(size: 14, design: .monospaced))
                }
            }
        } header: {
            HStack {
                Image(systemName: "hand.draw")
                Text("Feedback")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}

#Preview {
    HaebitFeedbackConfigSection()
}
