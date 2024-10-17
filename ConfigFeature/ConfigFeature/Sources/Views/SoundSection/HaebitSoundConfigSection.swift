//
//  HaebitSoundConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitSoundConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    
    var body: some View {
        Section {
            Toggle(isOn: $viewModel.shutterSound) {
                Text("ShutterSoundOption")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .tint(.yellow)
        } header: {
            HStack {
                Image(systemName: "speaker.wave.2")
                Text("Sound")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}
