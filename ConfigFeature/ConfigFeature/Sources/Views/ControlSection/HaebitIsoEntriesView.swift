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
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    @State private var isPresenting = false
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.isoEntries, id: \.self) { $isoEntry in
                    ToggleableEntry(title: isoEntry.value.title, isActive: $isoEntry.isActive)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .disabled(!viewModel.isToggleable(iso: isoEntry))
                        .swipeActions(edge: .trailing) {
                            if viewModel.isDeletable(iso: isoEntry) {
                                Button(role: .destructive) {
                                    viewModel.delete(iso: isoEntry)
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
                            .configViewControlSectionIsoEntriesDescription,
                        ]
                    )
                    AddEntryButton { isPresenting = true }
                }
                .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.configViewControlSectionIsoEntriesTitle)
        .animation(.easeInOut, value: viewModel.isoEntries.count)
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
                    maxDigitCount: 4,
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
