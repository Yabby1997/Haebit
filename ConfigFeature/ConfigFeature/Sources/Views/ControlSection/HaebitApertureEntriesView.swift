//
//  HaebitApertureEntriesConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitApertureEntriesConfigView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    @State private var isPresenting = false
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.apertureEntries, id: \.self) { $apertureEntry in
                    ToggleableEntry(title: apertureEntry.value.title, isActive: $apertureEntry.isActive)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .disabled(!viewModel.isToggleable(aperture: apertureEntry))
                        .swipeActions(edge: .trailing) {
                            if viewModel.isDeletable(aperture: apertureEntry) {
                                Button(role: .destructive) {
                                    viewModel.delete(aperture: apertureEntry)
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
                            .controlSectionCommonEntriesDescription,
                            .controlSectionApertureEntriesDescription,
                        ]
                    )
                    AddEntryButton { isPresenting = true }
                }
                .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(.controlSectionApertureTitle))
        .animation(.easeInOut, value: viewModel.apertureEntries.count)
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
                Text(.controlSectionCommonNewEntryTitle)
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
                let value = Float(numberString)
                numberString = ""
                guard let value, let aperture = ApertureValue(value) else { return }
                viewModel.add(aperture: aperture)
            }
        }
    }
}
