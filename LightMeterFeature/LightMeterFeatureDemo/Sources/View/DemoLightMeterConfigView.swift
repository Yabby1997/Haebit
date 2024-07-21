//
//  DemoLightMeterConfigView.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 5/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import PhotosUI
import SwiftUI

@MainActor
struct DemoLightMeterConfigView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedItem: PhotosPickerItem?
    @StateObject var viewModel: DemoLightMeterConfigViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Preview") {
                    PhotosPicker(selection: $selectedItem, preferredItemEncoding: .compatible) {
                        if let cgimage = viewModel.previewImage {
                            Image(uiImage: UIImage(cgImage: cgimage))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Text("Select photo")
                        }
                    }
                }
                Section("Exposure Value") {
                    VStack {
                        HStack {
                            Text("APT")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("Aperture", text: $viewModel.aperture)
                        }
                        HStack {
                            Text("SPD")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("ShutterSpeed", text: $viewModel.shutterSpeed)
                        }
                        HStack {
                            Text("ISO")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("ISO", text: $viewModel.iso)
                        }
                    }
                    .keyboardType(.decimalPad)
                }
                Section("Exposure Lock") {
                    VStack {
                        HStack {
                            Text("COD")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("X", text: $viewModel.lockPointX)
                                .multilineTextAlignment(.trailing)
                            Text(",")
                            TextField("Y", text: $viewModel.lockPointY)
                                .multilineTextAlignment(.leading)
                        }
                        .keyboardType(.decimalPad)
                        Toggle("Lock", isOn: $viewModel.isLocked)
                            .fontWeight(.bold)
                            .foregroundStyle(.yellow)
                        Button(action: viewModel.didTapResetLock) {
                            Text("Reset")
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Section("Values") {
                    VStack {
                        HStack {
                            Text("APT")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("Apertures", text: $viewModel.apertures)
                        }
                        HStack {
                            Text("SPD")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("ShutterSpeeds", text: $viewModel.shutterSpeeds)
                        }
                        HStack {
                            Text("ISO")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("ISOs", text: $viewModel.isos)
                        }
                        HStack {
                            Text("FCL")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            TextField("FocalLengths", text: $viewModel.focalLengths)
                        }
                    }
                }
                Section("Feedbacks") {
                    VStack {
                        HStack {
                            Text("APT")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            Picker("", selection: $viewModel.apertureFeedbackStyle) {
                                ForEach(FeedbackStyle.allCases) { feedbackStyle in
                                    Text(feedbackStyle.rawValue).tag(feedbackStyle)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        HStack {
                            Text("SPD")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            Picker("", selection: $viewModel.shutterSpeedFeedbackStyle) {
                                ForEach(FeedbackStyle.allCases) { feedbackStyle in
                                    Text(feedbackStyle.rawValue).tag(feedbackStyle)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        HStack {
                            Text("ISO")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            Picker("", selection: $viewModel.isoFeedbackStyle) {
                                ForEach(FeedbackStyle.allCases) { feedbackStyle in
                                    Text(feedbackStyle.rawValue).tag(feedbackStyle)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        HStack {
                            Text("FCL")
                                .fontWeight(.bold)
                                .foregroundStyle(.yellow)
                            Picker("", selection: $viewModel.focalLengthFeedbackStyle) {
                                ForEach(FeedbackStyle.allCases) { feedbackStyle in
                                    Text(feedbackStyle.rawValue).tag(feedbackStyle)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
            }
            .navigationTitle("Demo Config")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.didTapDismiss()
                        dismiss.callAsFunction()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
            .onChange(of: selectedItem) { value in
                guard let selectedItem else { return }
                Task {
                    guard let data = try? await selectedItem.loadTransferable(type: Data.self) else { return }
                    viewModel.previewImage = (UIImage(data: data)?.cgImage)
                }
            }
        }
    }
}
