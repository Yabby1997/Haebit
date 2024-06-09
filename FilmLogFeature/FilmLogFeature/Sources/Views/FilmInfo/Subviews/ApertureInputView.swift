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
    private let placeholder: String
    @State var numberString: String = ""
    @State var isEditing: Bool = false
    @Binding var value: ApertureValue
    
    init(value: Binding<ApertureValue>) {
        placeholder = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("조리개").font(.system(size: 18, weight: .bold))
            NumberField(
                numberString: $numberString,
                isEditing: $isEditing,
                format: .decimal,
                maxDigitCount: 3,
                prefix: "ƒ",
                placeholder: placeholder,
                font: .systemFont(ofSize: 40, weight: .bold, design: .monospaced)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onAppear { isEditing = true }
        .onDisappear {
            guard let decimalValue = Float(numberString),
                  let apertureValue = ApertureValue(decimalValue) else { return }
            value = apertureValue
        }
    }
}
