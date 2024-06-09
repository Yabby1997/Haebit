//
//  ShutterSpeedInputView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct ShutterSpeedInputView: View {
    enum Unit {
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
            case .denominator: return "¹⁄ 1000s"
            }
        }
        
        var prefix: String {
            switch self {
            case .seconds: ""
            case .denominator: "¹⁄ "
            }
        }
    }
    
    @State var numberString: String = ""
    @State var isEditing: Bool = false
    @State var selectedUnit: Unit
    @Binding var value: ShutterSpeedValue
    
    init(value: Binding<ShutterSpeedValue>) {
        selectedUnit = value.wrappedValue.value < 1.0 ? .denominator : .seconds
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("셔터속도").font(.system(size: 18, weight: .bold))
            NumberField(
                numberString: $numberString,
                isEditing: $isEditing,
                format: .integer,
                maxDigitCount: 5,
                prefix: selectedUnit.prefix,
                suffix: "s",
                placeholder: selectedUnit == (value.value < 1.0 ? .denominator : .seconds) ? value.description : selectedUnit.description,
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
                selectedUnit = selectedUnit.toggled
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onAppear { isEditing = true }
        .onDisappear {
            guard let value = UInt32(numberString) else { return }
            switch selectedUnit {
            case .seconds:
                guard let shutterSpeed = ShutterSpeedValue(numerator: value) else { return }
                self.value = shutterSpeed
            case .denominator:
                guard let shutterSpeed = ShutterSpeedValue(denominator: value) else { return }
                self.value = shutterSpeed
            }
        }
    }
}
