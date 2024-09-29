//
//  HaebitOtherConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitOtherConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                Text("OpenSource")
            } label: {
                Text("OpenSource")
                    .font(.system(size: 16, weight: .semibold))
            }
            NavigationLink(value: NavigatablePages.tipJar) {
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
                Text("Review on AppStore")
                    .font(.system(size: 16, weight: .semibold))
            }
            .onTapGesture(perform: viewModel.didTapReview)
            HStack {
                Text("Version \(viewModel.appVersion)"
                )
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text(viewModel.isLatestVersion ? "Latest" : "Update Available")
                    .font(.system(size: 14, design: .monospaced))
            }
            .onTapGesture(perform: viewModel.didTapAppVersion)
        } header: {
            HStack {
                Image(systemName: "text.bubble")
                Text("Other")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}
