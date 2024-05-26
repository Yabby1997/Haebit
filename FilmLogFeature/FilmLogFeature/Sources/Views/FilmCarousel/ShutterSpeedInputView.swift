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
    enum Selection: CaseIterable, Hashable {
        case second
        case underSecond
        
        var description: String {
            switch self {
            case .second: return "1s"
            case .underSecond: return "¹⁄ 1000s"
            }
        }
    }
    
    private let text: String
    @State var internalValue: String = ""
    @Binding var value: ShutterSpeedValue
    @FocusState var isFocused: Bool
    
    @State var selection: Selection
    
    init(value: Binding<ShutterSpeedValue>) {
        text = value.wrappedValue.description
        selection = value.wrappedValue.value < 1.0 ? .underSecond : .second
        self._value = value
    }
    
    var body: some View {
        VStack {
            TextField(text, text: $internalValue)
                .font(.system(size: 40, weight: .bold, design: .serif))
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .keyboardType(.numberPad)
                .focused($isFocused)
                .padding()
                .onAppear { isFocused = true }
                .onChange(of: internalValue) { value in
                    guard value.isEmpty == false else { return }
                    switch selection {
                    case .second:
                        let numbers = value.filter { $0.isNumber }
                        internalValue = "\(numbers)s"
                    case .underSecond:
                        let trimmed = value.trimmingCharacters(in: ["s", "¹", "⁄"])
                        let numbers = trimmed.filter { $0.isNumber }
                        internalValue = "¹⁄ \(numbers)s"
                    }
                }
            Picker("", selection: $selection) {
                ForEach(Selection.allCases, id: \.self) {
                    Text($0.description)
              }
            }
            .font(.system(size: 20, weight: .bold, design: .serif))
            .padding(.horizontal, 20)
            .onChange(of: selection) { _ in
                internalValue = ""
            }
            .pickerStyle(.segmented)
        }
        .onDisappear {
            let trimmed = internalValue.trimmingCharacters(in: ["s", "¹", "⁄", " "])
            switch selection {
            case .second:
                if let seconds = Int(trimmed),
                   let shutterSpeed = ShutterSpeedValue(seconds: seconds) {
                    value = shutterSpeed
                }
            case .underSecond:
                if let denominator = Float(trimmed),
                   let shutterSpeed = ShutterSpeedValue(denominator: denominator) {
                    value = shutterSpeed
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    @State var shutterSpeed = ShutterSpeedValue(seconds: 1)!
    return ShutterSpeedInputView(value: $shutterSpeed)
}
