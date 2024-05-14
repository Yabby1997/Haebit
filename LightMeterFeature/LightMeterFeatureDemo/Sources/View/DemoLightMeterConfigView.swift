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
    @StateObject var viewModel: DemoLightMeterViewModel
    
    @State var exposureValueString = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Fake Preview") {
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
                    FloatField("EV", float: $viewModel.exposureValue)
                }
                Section("Exposure Lock") {
                    HStack {
                        FloatField("X", float: $viewModel.lockPointX)
                        FloatField("Y", float: $viewModel.lockPointY)
                    }
                    Toggle("Lock", isOn: $viewModel.isLocked)
                    Button(action: viewModel.resetLock) {
                        Text("Reset")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Register")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .onChange(of: selectedItem) { value in
                guard let selectedItem else { return }
                Task {
                    guard let data = try? await selectedItem.loadTransferable(type: Data.self) else { return }
                    viewModel.setPreview(UIImage(data: data)?.cgImage)
                }
            }
        }
    }
}

extension PhotosPickerItem: @unchecked Sendable {}
