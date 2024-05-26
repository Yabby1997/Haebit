//
//  ApertureInputView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct ApertureInputView: View {
    let text: String
    @State var internalValue: String = ""
    @Binding var value: ApertureValue
    @FocusState var isFocused: Bool
    
    init(value: Binding<ApertureValue>) {
        text = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        TextField(text, text: $internalValue)
            .font(.system(size: 40, weight: .bold, design: .monospaced))
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .preferredColorScheme(.dark)
            .padding()
            .onAppear { isFocused = true }
            .onDisappear {
                if let float = Float(internalValue.trimmingCharacters(in: ["ƒ"])) {
                    value = ApertureValue(value: float)
                }
                internalValue = ""
            }
            .onChange(of: internalValue) { value in
                guard value.isEmpty == false else { return }
                internalValue = value.reduce(into: "ƒ") {
                    if $1.isNumber || ($1 == "." && !$0.contains(".")) || ($1 == "-" && $0.isEmpty) {
                        $0.append($1)
                    }
                }
            }
    }
}


#Preview {
    @State var aperture = ApertureValue(value: 1.4)
    return ApertureInputView(value: $aperture)
}
