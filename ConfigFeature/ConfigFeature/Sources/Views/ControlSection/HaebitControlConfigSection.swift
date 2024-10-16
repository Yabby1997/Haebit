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
                        HStack(spacing: 4) {
                            Text("\(singleValue.description)")
                                .font(.system(size: 14, design: .monospaced))
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                        }
                    } else {
                        Text("\(viewModel.apertures.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitShutterSpeedEntriesView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text("ShutterSpeed")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.shutterSpeeds.count == 1, let singleValue = viewModel.shutterSpeeds.first {
                        HStack(spacing: 4) {
                            Text("\(singleValue.description)")
                                .font(.system(size: 14, design: .monospaced))
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                        }
                    } else {
                        Text("\(viewModel.shutterSpeeds.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitIsoEntriesView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text("ISO")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.isoValues.count == 1, let singleValue = viewModel.isoValues.first {
                        HStack(spacing: 4) {
                            Text("\(singleValue.description)")
                                .font(.system(size: 14, design: .monospaced))
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                        }
                    } else {
                        Text("\(viewModel.isoValues.count) items")
                            .font(.system(size: 14, design: .monospaced))
                    }
                }
            }
            NavigationLink {
                HaebitFocalLengthEntriesView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text("FocalLength")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.focalLengths.count == 1, let singleValue = viewModel.focalLengths.first {
                        HStack(spacing: 4) {
                            Text("\(singleValue.title)")
                                .font(.system(size: 14, design: .monospaced))
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                        }
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
            Text("ControlDescription")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .listRowInsets(.init(top: 8, leading: 8, bottom: 12, trailing: 8))
        }
        .id(ConfigSection.control)
        .foregroundStyle(viewModel.highlightedSection == .control ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
