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
    var body: some View {
        HaebitConfigView(
            appStoreOpener: RealAppStoreOpener(
                locale: Locale.current.region?.identifier ?? "kr",
                appID: "id6474086258"
            )
        )
    }
}

#Preview {
    ContentView()
}
