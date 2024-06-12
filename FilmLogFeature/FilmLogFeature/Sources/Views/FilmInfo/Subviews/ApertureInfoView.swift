//
//  ApertureInfoView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct ApertureInfoView: View {
    private let placeholder: String
    @Binding var value: ApertureValue
    @State var numberString = ""
    @State var isEditing = false
    @State var isPresenting = false
    
    init(value: Binding<ApertureValue>) {
        placeholder = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(.apertureInputViewTitle)
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
                Text(.apertureInputViewTitle).font(.system(size: 18, weight: .bold))
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
}
