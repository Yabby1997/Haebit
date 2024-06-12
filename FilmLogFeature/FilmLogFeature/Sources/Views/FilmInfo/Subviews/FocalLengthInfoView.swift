//
//  FocalLengthInfoView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct FocalLengthInfoView: View {
    private let placeholder: String
    @Binding var value: FocalLengthValue
    @State var numberString = ""
    @State var isEditing = false
    @State var isPresenting = false
    
    init(value: Binding<FocalLengthValue>) {
        placeholder = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(.focalLengthInputViewTitle)
                .font(.system(size: 12, weight: .semibold))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(value.title)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .lineLimit(1)
                .animation(.easeInOut, value: value)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { isPresenting = true }
        .bottomSheet(isPresented: $isPresenting) {
            VStack(alignment: .center, spacing: 8) {
                Text(.focalLengthInputViewTitle).font(.system(size: 18, weight: .bold))
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
}
