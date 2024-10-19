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
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    @State private var isPresenting = false
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.focalLengthEntries, id: \.self) { $focalLengthEntry in
                    ToggleableEntry(title: focalLengthEntry.value.title, isActive: $focalLengthEntry.isActive)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .disabled(!viewModel.isToggleable(focalLength: focalLengthEntry))
                        .swipeActions(edge: .trailing) {
                            if viewModel.isDeletable(focalLength: focalLengthEntry) {
                                Button(role: .destructive) {
                                    viewModel.delete(focalLength: focalLengthEntry)
                                } label: {
                                    Image.trash
                                }
                            }
                        }
                }
            } footer: {
                VStack(spacing: 20) {
                    BulletedList(
                        listItems: [
                            .configViewControlSectionCommonEntriesDescription,
                            .configViewControlSectionFocalLengthEntriesDescription,
                            .configViewControlSectionFocalLengthEntriesDescription2
                        ]
                    )
                    AddEntryButton { isPresenting = true }
                }
                .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.configViewControlSectionFocalLengthEntriesTitle)
        .animation(.easeInOut, value: viewModel.focalLengthEntries.count)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = false
                } label: {
                    Image.xmark
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.arrowBackward
                        .foregroundStyle(.white)
                }
            }
        }
        .bottomSheet(isPresented: $isPresenting) {
            VStack(alignment: .center, spacing: 8) {
                Text(.configViewControlSectionCommonNewEntryTitle)
                    .font(.system(size: 18, weight: .bold))
                NumberField(
                    numberString: $numberString,
                    isEditing: $isEditing,
                    format: .integer,
                    maxDigitCount: 3,
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
