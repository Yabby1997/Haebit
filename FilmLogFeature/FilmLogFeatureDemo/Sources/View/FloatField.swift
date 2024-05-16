//
//  FloatField.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 5/15/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct FloatField: View {
    private let titleKey: LocalizedStringKey
    @Binding private var float: Float?
    @State private var internalString: String
    
    init(_ titleKey: LocalizedStringKey, float: Binding<Float?>) {
        self.titleKey = titleKey
        self._float = float
        self._internalString = State(initialValue: float.wrappedValue.map { String($0) } ?? "")
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
        self._internalString = State(initialValue: String(float.wrappedValue))
    }
    
    var body: some View {
        TextField(titleKey, text: $internalString)
            .autocorrectionDisabled()
            .keyboardType(.decimalPad)
            .onChange(of: internalString) { newValue in
                let filtered = newValue.reduce(into: "") { if $1.isNumber || ($1 == "." && !$0.contains(".")) || ($1 == "-" && $0.isEmpty) { $0.append($1) } }
                let result = filtered == "." ? "0." : filtered
                internalString = result
                float = Float(result)
            }
            .onChange(of: float) { newValue in
                guard newValue == nil else { return }
                internalString = ""
            }
    }
}
