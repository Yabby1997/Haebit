//
//  ContentView.swift
//  ConfigFeatureDemo
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import ConfigFeature

struct ContentView: View {
    @State var isPresenting = false
    
    var body: some View {
        VStack {
            Button("Open") {
                isPresenting = true
            }
        }
        .fullScreenCover(isPresented: $isPresenting) {
            HaebitConfigView(
                configRepository: MockConfigRepository(),
                appStoreOpener: RealAppStoreOpener(
                    locale: Locale.current.region?.identifier ?? "kr",
                    appID: "6474086258"
                ),
                appVersionProvider: MockAppVersionProvider(),
                isPresented: $isPresenting
            )
        }
    }
}

#Preview {
    ContentView()
}
