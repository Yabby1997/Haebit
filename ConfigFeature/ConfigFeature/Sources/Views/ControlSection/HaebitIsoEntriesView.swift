//
//  HaebitIsoEntriesView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitIsoEntriesView: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPresenting = false
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.isoEntries, id: \.self) { $isoEntry in
                    HStack {
                        Text(isoEntry.value.title)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(isoEntry.isActive ? .white : .gray)
                        Spacer()
                        Toggle(isOn: $isoEntry.isActive, label: {})
                            .labelsHidden()
                            .disabled(!viewModel.isToggleable(iso: isoEntry))
                    }
                    .deleteDisabled(!viewModel.isDeletable(iso: isoEntry))
                }
                .onDelete { offset in
                    viewModel.deleteIso(at: offset)
                }
            } footer: {
                Text("At least one value should be exist and active.")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ISO Entries")
        .animation(.easeInOut, value: viewModel.isoEntries.count)
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
                Text("New ISO Value")
                    .font(.system(size: 18, weight: .bold))
                NumberField(
                    numberString: $numberString,
                    isEditing: $isEditing,
                    format: .integer,
                    maxDigitCount: 5,
                    placeholder: "200",
                    font: .systemFont(ofSize: 40, weight: .bold, design: .serif)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .onAppear { isEditing = true }
            .onDisappear {
                let value = UInt32(numberString)
                numberString = ""
                guard let value, let isoValue = IsoValue(value) else { return }
                viewModel.add(iso: isoValue)
            }
        }
    }
}
