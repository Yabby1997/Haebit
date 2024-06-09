//
//  IsoInputView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct IsoInputView: View {
    private let placeholder: String
    @State var numberString: String = ""
    @State var isEditing: Bool = false
    @Binding var value: IsoValue
    
    init(value: Binding<IsoValue>) {
        placeholder = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("감도").font(.system(size: 18, weight: .bold))
            NumberField(
                numberString: $numberString,
                isEditing: $isEditing,
                format: .integer,
                maxDigitCount: 5,
                placeholder: placeholder,
                font: .systemFont(ofSize: 40, weight: .bold, design: .serif)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .onAppear { isEditing = true }
        .onDisappear {
            guard let integerValue = UInt32(numberString),
                  let isoValue = IsoValue(integerValue) else { return }
            value = isoValue
        }
    }
}
