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
            ConfigToggle(title: .soundSectionShutterSoundOptionTitle, isOn: $viewModel.shutterSound)
        } header: {
            HStack {
                Image.speakerWave2
                Text(.soundSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.sound)
        .foregroundStyle(viewModel.highlightedSection == .sound ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
