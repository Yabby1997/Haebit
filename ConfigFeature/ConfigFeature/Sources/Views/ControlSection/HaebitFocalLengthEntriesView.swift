//
//  HaebitFocalLengthEntriesView.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitFocalLengthEntriesView: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPresenting = false
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.focalLengthEntries, id: \.self) { $focalLengthEntry in
                    HStack {
                        Text(focalLengthEntry.value.title)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(focalLengthEntry.isActive ? .white : .gray)
                        Spacer()
                        Toggle(isOn: $focalLengthEntry.isActive, label: {})
                            .labelsHidden()
                            .disabled(!viewModel.isToggleable(focalLength: focalLengthEntry))
                    }
                    .deleteDisabled(!viewModel.isDeletable(focalLength: focalLengthEntry))
                }
                .onDelete { offset in
                    viewModel.deleteFocalLength(at: offset)
                }
            } footer: {
                Text("At least one value should be exist and active.")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Focal Length Entries")
        .animation(.easeInOut, value: viewModel.focalLengthEntries.count)
        .scrollIndicators(.hidden)
        .headerProminence(.increased)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresenting = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundStyle(.white)
                }
            }
        }
        .bottomSheet(isPresented: $isPresenting) {
            VStack(alignment: .center, spacing: 8) {
                Text("New Focal Length Value")
                    .font(.system(size: 18, weight: .bold))
                NumberField(
                    numberString: $numberString,
                    isEditing: $isEditing,
                    format: .integer,
                    maxDigitCount: 5,
                    suffix: "mm",
                    placeholder: "50mm",
                    font: .systemFont(ofSize: 40, weight: .bold, design: .monospaced)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .onAppear { isEditing = true }
            .onDisappear {
                let value = UInt32(numberString)
                numberString = ""
                guard let value, let focalLength = FocalLengthValue(value) else { return }
                viewModel.add(focalLength: focalLength)
            }
        }
    }
}
