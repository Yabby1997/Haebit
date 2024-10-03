//
//  HaebitControlConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitControlConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool

    var body: some View {
        Section {
            NavigationLink {
                HaebitApertureEntriesConfigView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text("Aperture")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.apertures.count == 1, let singleValue = viewModel.apertures.first {
                        HStack {
                            Text("\(singleValue.description)")
                            Image(systemName: "lock.fill")
                        }
                        .font(.system(size: 14, design: .monospaced))
                    } else {
                        Text("\(viewModel.apertures.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitShutterSpeedEntriesView(viewModel: viewModel)
            } label: {
                HStack {
                    Text("Shutter Speed")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.shutterSpeeds.count == 1, let singleValue = viewModel.shutterSpeeds.first {
                        HStack {
                            Text("\(singleValue.description)")
                            Image(systemName: "lock.fill")
                        }
                        .font(.system(size: 14, design: .monospaced))
                    } else {
                        Text("\(viewModel.shutterSpeeds.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitIsoEntriesView(viewModel: viewModel)
            } label: {
                HStack {
                    Text("ISO")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.isoValues.count == 1, let singleValue = viewModel.isoValues.first {
                        HStack {
                            Text("\(singleValue.description)")
                            Image(systemName: "lock.fill")
                        }
                        .font(.system(size: 14, design: .monospaced))
                    } else {
                        Text("\(viewModel.isoValues.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitFocalLengthEntriesView(viewModel: viewModel)
            } label: {
                HStack {
                    Text("Focal Length")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.focalLengths.count == 1, let singleValue = viewModel.focalLengths.first {
                        HStack {
                            Text("\(singleValue.title)")
                            Image(systemName: "lock.fill")
                        }
                        .font(.system(size: 14, design: .monospaced))
                    } else {
                        Text("\(viewModel.focalLengths.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
        } header: {
            HStack {
                Image(systemName: "f.cursive")
                Text("Control")
            }
            .font(.system(size: 14, weight: .bold))
        } footer: {
            VStack(alignment: .leading) {
                BulletedText("Types with only one entry will be locked and won't be displayed as a control.")
            }
        }
    }
}
