//
//  HaebitShutterSpeedEntriesView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

fileprivate enum Unit {
    case seconds
    case denominator
    
    var toggled: Unit {
        switch self {
        case .seconds: return .denominator
        case .denominator: return .seconds
        }
    }
    
    var description: String {
        switch self {
        case .seconds: return "1s"
        case .denominator: return "¹⁄ 60s"
        }
    }
    
    var prefix: String {
        switch self {
        case .seconds: ""
        case .denominator: "¹⁄ "
        }
    }
    
    var maxDigits: Int {
        switch self {
        case .seconds: 2
        case .denominator: 5
        }
    }
}

struct HaebitShutterSpeedEntriesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    @State private var isPresenting = false
    @State private var selectedUnit: Unit = .denominator
    @State private var numberString = ""
    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                ForEach($viewModel.shutterSpeedEntries, id: \.self) { $shutterSpeedEntry in
                    ToggleableEntry(
                        title: shutterSpeedEntry.value.description.replacingOccurrences(of: "⁄", with: "⁄ "),
                        isActive: $shutterSpeedEntry.isActive
                    )
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .disabled(!viewModel.isToggleable(shutterSpeed: shutterSpeedEntry))
                    .swipeActions(edge: .trailing) {
                        if viewModel.isDeletable(shutterSpeed: shutterSpeedEntry) {
                            Button(role: .destructive) {
                                viewModel.delete(shutterSpeed: shutterSpeedEntry)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            } footer: {
                VStack(spacing: 20) {
                    BulletedList(
                        listItems: [
                            "At least one entry should be exist and active.",
                            "If aperture and ISO has only one entry, at least two entries should be exist and active.",
                        ]
                    )
                    AddEntryButton { isPresenting = true }
                }
                .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Shutter Speed Entries")
        .animation(.easeInOut, value: viewModel.shutterSpeedEntries.count)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
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
                Text("New Entry")
                    .font(.system(size: 18, weight: .bold))
                NumberField(
                    numberString: $numberString,
                    isEditing: $isEditing,
                    format: .integer,
                    maxDigitCount: selectedUnit.maxDigits,
                    prefix: selectedUnit.prefix,
                    suffix: "s",
                    placeholder: selectedUnit.description,
                    font: .systemFont(ofSize: 40, weight: .bold, design: .serif)
                )
                HStack(spacing: 2) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 12, weight: .bold, design: .serif))
                    Text(selectedUnit.toggled.description)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                }
                .animation(.easeInOut, value: selectedUnit)
                .contentTransition(.numericText())
                .foregroundStyle(.yellow)
                .onTapGesture {
                    let toggled = selectedUnit.toggled
                    if toggled.maxDigits < numberString.count {
                        numberString = String(numberString.prefix(toggled.maxDigits))
                    }
                    selectedUnit = toggled
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .onAppear { isEditing = true }
            .onDisappear {
                let value = UInt32(numberString)
                numberString = ""
                guard let value else { return }
                switch selectedUnit {
                case .seconds:
                    guard let shutterSpeed = ShutterSpeedValue(numerator: value) else { return }
                    viewModel.add(shutterSpeed: shutterSpeed)
                case .denominator:
                    guard let shutterSpeed = ShutterSpeedValue(denominator: value) else { return }
                    viewModel.add(shutterSpeed: shutterSpeed)
                }
            }
        }
    }
}
