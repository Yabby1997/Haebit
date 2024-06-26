//
//  ShutterSpeedInfoView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct ShutterSpeedInfoView: View {
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
    
    @Binding var value: ShutterSpeedValue
    @State var selectedUnit: Unit
    @State var numberString = ""
    @State var isEditing = false
    @State var isPresenting = false
    
    init(value: Binding<ShutterSpeedValue>) {
        selectedUnit = value.wrappedValue.value < 1.0 ? .denominator : .seconds
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(.shutterSpeedInputViewTitle)
                .font(.system(size: 12, weight: .semibold))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(value.description)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .lineLimit(1)
                .animation(.easeInOut, value: value)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { isPresenting = true }
        .bottomSheet(isPresented: $isPresenting) {
            VStack(alignment: .center, spacing: 8) {
                Text(.shutterSpeedInputViewTitle).font(.system(size: 18, weight: .bold))
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
}
