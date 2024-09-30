//
//  HaebitApertureEntriesConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitApertureEntriesConfigView: View {
    @StateObject var viewModel: HaebitConfigViewModel
    
    var body: some View {
        List {
            Section {
                ForEach($viewModel.apertureEntries, id: \.self) { $entry in
                    HStack {
                        Text(entry.value.title)
                        Spacer()
                        Toggle(isOn: $entry.isActive, label: {})
                            .labelsHidden()
                            .disabled(!viewModel.isToggleable(aperture: entry))
                    }
                    .deleteDisabled(!viewModel.isDeletable(aperture: entry))
                }
                .onDelete { offset in
                    viewModel.deleteApertures(at: offset)
                }
            } footer: {
                Text("At least one value should be exist and active.")
            }
        }
    }
}
