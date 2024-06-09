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
    private let placeholder: String
    @State var numberString: String = ""
    @State var isEditing: Bool = false
    @Binding var value: FocalLengthValue
    
    init(value: Binding<FocalLengthValue>) {
        placeholder = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("초점거리").font(.system(size: 18, weight: .bold))
            NumberField(
                numberString: $numberString,
                isEditing: $isEditing,
                format: .integer,
                maxDigitCount: 5,
                suffix: "mm",
                placeholder: placeholder,
                font: .systemFont(ofSize: 40, weight: .bold, design: .monospaced)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onAppear { isEditing = true }
        .onDisappear {
            guard let integerValue = UInt32(numberString),
                  let focalLength = FocalLengthValue(integerValue) else { return }
            value = focalLength
        }
    }
}
