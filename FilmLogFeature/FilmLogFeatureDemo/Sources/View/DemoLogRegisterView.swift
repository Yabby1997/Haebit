//
//  DemoLogRegisterView.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import PhotosUI
import SwiftUI

@MainActor
struct DemoLogRegisterView: View {
    @StateObject var viewModel: DemoLogRegisterViewModel
    @Binding var isPresented: Bool
    @State var selectedItem: PhotosPickerItem?
    @State var image: Image?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section("Photo") {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .any(of: [.images])
                        ) {
                            if let image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Text("Select image")
                            }
                        }
                    }
                    Section("Date") {
                        DatePicker("Date", selection: $viewModel.date)
                    }
                    Section("Coordinate") {
                        HStack {
                            FloatField("Latitude", float: $viewModel.latitude)
                            FloatField("Longitude", float: $viewModel.longitude)
                        }
                    }
                    Section("Lens") {
                        HStack {
                            TextField("Focal length", value: $viewModel.focalLength, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        FloatField("Aperture", float: $viewModel.aperture)
                    }
                    Section("Exposure Settings") {
                        TextField("ISO", value: $viewModel.iso, format: .number)
                            .keyboardType(.decimalPad)
                        HStack {
                            TextField("1", value: $viewModel.shutterSpeedNumerator, format: .number)
                            Text("/")
                            TextField("60", value: $viewModel.shutterSpeedDenominator, format: .number)
                            Text("s")
                        }
                        .keyboardType(.decimalPad)
                    }
                    Section("Memo") {
                        TextEditor(text: $viewModel.memo)
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
            .autocorrectionDisabled()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: viewModel.register) {
                        Text("Add")
                    }
                    .disabled(!viewModel.isRegisterable)
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Register")
            .onChange(of: selectedItem) { _ in
                Task {
                    let (data, image) = try await Task.detached {
                        let data = try await selectedItem?.loadTransferable(type: Data.self)
                        let image = try await selectedItem?.loadTransferable(type: Image.self)
                        return (data, image)
                    }.value
                    guard let data, let image else { return }
                    viewModel.imageData = data
                    self.image = image
                }
            }
            .onChange(of: viewModel.imageData) { newValue in
                guard newValue == nil else { return }
                image = nil
            }
        }
    }
}
