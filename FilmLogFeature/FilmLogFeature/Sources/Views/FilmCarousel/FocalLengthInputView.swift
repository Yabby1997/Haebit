//
//  FocalLengthInputView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct FocalLengthInputView: View {
    let text: String
    @State var internalValue: String = ""
    @Binding var value: FocalLengthValue
    @FocusState var isFocused: Bool
    
    init(value: Binding<FocalLengthValue>) {
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
                if let length = Int(internalValue.trimmingCharacters(in: ["m"])) {
                    value = FocalLengthValue(value: length)
                }
                internalValue = ""
            }
            .onChange(of: internalValue) { value in
                guard value.isEmpty == false else { return }
                let numbers = value.filter { $0.isNumber }
                internalValue = "\(numbers)mm"
            }
    }
}


#Preview {
    @State var focalLength = FocalLengthValue(value: 200)
    return FocalLengthInputView(value: $focalLength)
}
