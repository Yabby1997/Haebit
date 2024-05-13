//
//  DemoLightMeterConfigView.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 5/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import PhotosUI
import SwiftUI

struct DemoLightMeterConfigView: View {
    @State var item: PhotosPickerItem?
    @StateObject var viewModel: DemoLightMeterViewModel
    
    var body: some View {
        List {
            Section("Fake Preview") {
                PhotosPicker(selection: $item) {
                    if item != nil {
                        Text("Photo selected!")
                    } else {
                        Text("Select photo")
                    }
                }
            }
            Section("Exposure Value") {
                TextField("EV", value: $viewModel.exposureValue, format: .number)
                    .keyboardType(.decimalPad)
            }
            Section("Lock") {
                HStack {
                    TextField("X", value: $viewModel.lockPointX, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Y", value: $viewModel.lockPointY, format: .number)
                        .keyboardType(.decimalPad)
                }
                Toggle("Lock", isOn: $viewModel.isLocked)
                Button(action: viewModel.resetLock) {
                    Text("Reset")
                }
            }
        }
        .onChange(of: item) { value in
            Task {
                guard let imageData = try? await item?.loadTransferable(type: Data.self) else {
                    return
                }
                await viewModel.setImage(UIImage(data: imageData)?.cgImage)
            }
        }
    }
}
