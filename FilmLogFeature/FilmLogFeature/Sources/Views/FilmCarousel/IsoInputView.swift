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
    let text: String
    @State var internalValue: String = ""
    @Binding var value: IsoValue
    @FocusState var isFocused: Bool
    
    init(value: Binding<IsoValue>) {
        text = value.wrappedValue.title
        self._value = value
    }
    
    var body: some View {
        TextField(text, text: $internalValue)
            .font(.system(size: 40, weight: .bold, design: .serif))
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .preferredColorScheme(.dark)
            .padding()
            .onAppear { isFocused = true }
            .onDisappear {
                if let iso = Int(internalValue) {
                    value = IsoValue(iso: iso)
                }
                internalValue = ""
            }
            .onChange(of: internalValue) { value in
                internalValue = value.filter { $0.isNumber }
            }
    }
}


#Preview {
    @State var iso = IsoValue(iso: 400)
    return IsoInputView(value: $iso)
}
