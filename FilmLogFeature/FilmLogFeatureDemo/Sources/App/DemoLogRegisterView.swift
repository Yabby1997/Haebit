//
//  DemoLogRegisterView.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import PhotosUI

struct DemoLogRegisterView: View {
    @StateObject var viewModel: DemoLogRegisterViewModel
    @State var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            List {
                DatePicker("Date", selection: $viewModel.date)
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .any(of: [.images])
                ) {
                    if viewModel.imageData != nil {
                        Text("Image selected!")
                    } else {
                        Text("Select image")
                    }
                }
                HStack {
                    Text("Latitude")
                    TextField("Latitude", value: $viewModel.latitude, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Longitude")
                    TextField("Latitude", value: $viewModel.longitude, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("FocalLength")
                    TextField("FocalLength", value: $viewModel.focalLength, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("ISO")
                    TextField("ISO", value: $viewModel.iso, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("ShutterSpeed")
                    TextField("ShutterSpeed", value: $viewModel.shutterSpeed, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Aperture")
                    TextField("Aperture", value: $viewModel.aperture, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Memo")
                    TextField("Memo", text: $viewModel.memo)
                        .multilineTextAlignment(.trailing)
                }
            }
            VStack {
                Spacer()
                Button(action: viewModel.register) {
                    Text("Register")
                }
            }
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                    ProgressView()
                }
                .ignoresSafeArea()
            }
        }
        .onChange(of: selectedItem) { _ in
            Task {
                let data = try await Task.detached {
                    return try await selectedItem?.loadTransferable(type: Data.self)
                }.value
                guard let data else { return }
                viewModel.imageData = data
            }
        }
    }
}
