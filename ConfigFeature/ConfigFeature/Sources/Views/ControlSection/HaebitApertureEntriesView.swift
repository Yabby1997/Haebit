//
//  HaebitApertureEntriesConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitApertureEntriesConfigView: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isPresenting = false
    @State var numberString = ""
    @State var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.apertureEntries, id: \.self) { $apertureEntry in
                    HStack {
                        Text(apertureEntry.value.title)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(apertureEntry.isActive ? .white : .gray)
                        Spacer()
                        Toggle(isOn: $apertureEntry.isActive, label: {})
                            .labelsHidden()
                            .disabled(!viewModel.isToggleable(aperture: apertureEntry))
                    }
                    .deleteDisabled(!viewModel.isDeletable(aperture: apertureEntry))
                }
                .onDelete { offset in
                    viewModel.deleteApertures(at: offset)
                }
            } footer: {
                Text("At least one value should be exist and active.")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Aperture Entries")
        .animation(.easeInOut, value: viewModel.apertureEntries.count)
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
                Text("New Aperture Value")
                    .font(.system(size: 18, weight: .bold))
                NumberField(
                    numberString: $numberString,
                    isEditing: $isEditing,
                    format: .decimal,
                    maxDigitCount: 3,
                    prefix: "ƒ",
                    placeholder: "ƒ1.4",
                    font: .systemFont(ofSize: 40, weight: .bold, design: .monospaced)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .onAppear { isEditing = true }
            .onDisappear {
                viewModel.add(apertureValue: numberString)
                numberString = ""
            }
        }
    }
}
