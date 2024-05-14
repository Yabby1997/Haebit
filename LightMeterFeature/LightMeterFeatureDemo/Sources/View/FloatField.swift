//
//  FloatField.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct FloatField: View {
    let titleKey: LocalizedStringKey
    @Binding var float: Float?
    @State var displayString: String
    
    init(_ titleKey: LocalizedStringKey, float: Binding<Float?>) {
        self.titleKey = titleKey
        self._float = float
        if let initialValue = float.wrappedValue {
            self._displayString = State(initialValue: String(initialValue))
        } else {
            self._displayString = State(initialValue: "")
        }
    }
    
    init(_ titleKey: LocalizedStringKey, float: Binding<Float>) {
        self.titleKey = titleKey
        let optionalFloat = Binding<Float?>(
            get: { float.wrappedValue },
            set: { newValue in
                if let newValue = newValue {
                    float.wrappedValue = newValue
                }
            }
        )
        self._float = optionalFloat
        self._displayString = State(initialValue: String(float.wrappedValue))
    }
    
    var body: some View {
        TextField(titleKey, text: $displayString)
            .keyboardType(.decimalPad)
            .onChange(of: displayString) { _ in
                let filtered = displayString.filter { "0123456789.".contains($0) }
                let splitted = filtered.split(separator: ".")
                if splitted.count == 2 {
                    let preDecimal = String(splitted[0])
                    let afterDecimal = String(splitted[1])
                    displayString = "\(preDecimal).\(afterDecimal)"
                }
                float = Float(displayString) ?? .zero
            }
    }
}
