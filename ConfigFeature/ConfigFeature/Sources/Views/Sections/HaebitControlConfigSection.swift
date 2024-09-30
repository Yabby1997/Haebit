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

    var body: some View {
        Section {
            NavigationLink {
                Text("Aperture")
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
                Text("Shutter Speed")
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
                Text("ISO")
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
                Text("Focal Length")
            } label: {
                HStack {
                    Text("Focal Length")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if viewModel.focalLenghts.count == 1, let singleValue = viewModel.focalLenghts.first {
                        HStack {
                            Text("\(singleValue.title)")
                            Image(systemName: "lock.fill")
                        }
                        .font(.system(size: 14, design: .monospaced))
                    } else {
                        Text("\(viewModel.focalLenghts.count) items")
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
            Text("At least a type of exposure related value should have more than two items.")
        }
    }
}
