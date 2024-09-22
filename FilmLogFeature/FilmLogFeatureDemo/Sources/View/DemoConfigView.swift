//
//  DemoConfigView.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import PhotosUI
import SwiftUI
import HaebitCommonModels

@MainActor
struct DemoConfigView: View {
    @StateObject var viewModel: DemoConfigViewModel
    @Binding var isPresented: Bool
    @State var selectedItem: PhotosPickerItem?
    @State var image: Image?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
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
                        DatePicker("Date", selection: $viewModel.date)
                        HStack {
                            FloatField("Latitude", float: $viewModel.latitude)
                            FloatField("Longitude", float: $viewModel.longitude)
                        }
                        HStack {
                            TextField("Focal length", value: $viewModel.focalLength, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        FloatField("Aperture", float: $viewModel.aperture)
                        TextField("ISO", value: $viewModel.iso, format: .number)
                            .keyboardType(.decimalPad)
                        HStack {
                            TextField("1", value: $viewModel.shutterSpeedNumerator, format: .number)
                            Text("/")
                            TextField("60", value: $viewModel.shutterSpeedDenominator, format: .number)
                            Text("s")
                        }
                        .keyboardType(.decimalPad)
                        TextEditor(text: $viewModel.memo)
                    } header: {
                        HStack {
                            Text("Register")
                            Spacer()
                            Button(action: viewModel.register) {
                                Text("Add")
                            }
                            .disabled(!viewModel.isRegisterable)
                        }
                    }
                    Section("Perforation Shape") {
                        Picker("", selection: $viewModel.perforationShape) {
                            ForEach(PerforationShape.allCases, id: \.self) { shape in
                                Text(shape.description)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        viewModel.onClose()
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Config")
            .onChange(of: selectedItem) { _ in
                Task {
                    let data = try await selectedItem?.loadTransferable(type: Data.self)
                    guard let data, let uiImage = UIImage(data: data) else { return }
                    viewModel.imageData = data
                    self.image = Image(uiImage: uiImage)
                }
            }
            .onChange(of: viewModel.imageData) { newValue in
                guard newValue == nil else { return }
                image = nil
            }
        }
    }
}
