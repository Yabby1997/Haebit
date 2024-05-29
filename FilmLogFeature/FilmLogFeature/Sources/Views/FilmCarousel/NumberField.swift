//
//  NumberField.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

@MainActor
struct NumberField: UIViewRepresentable {
    enum Format {
        case integer
        case decimal
        
        var keyaboardType: UIKeyboardType {
            switch self {
            case .integer: return .numberPad
            case .decimal: return .decimalPad
            }
        }
    }
    
    @Binding var numberString: String
    @Binding var isEditing: Bool
    let format: Format
    let maxDigitCount: Int?
    let prefix: String
    let suffix: String
    let placeholder: String
    let font: UIFont
    let appearance: UIKeyboardAppearance
    
    init(
        numberString: Binding<String>,
        isEditing: Binding<Bool>,
        format: Format,
        maxDigitCount: Int? = nil,
        prefix: String = "",
        suffix: String = "",
        placeholder: String = "",
        font: UIFont = .systemFont(ofSize: 20),
        appearance: UIKeyboardAppearance = .default
    ) {
        _numberString = numberString
        _isEditing = isEditing
        self.format = format
        self.maxDigitCount = maxDigitCount
        self.prefix = prefix
        self.suffix = suffix
        self.placeholder = placeholder
        self.font = font
        self.appearance = appearance
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        let intrinsicSize = uiView.intrinsicContentSize
        let proposedSize = CGSize(
            width: proposal.width ?? .greatestFiniteMagnitude,
            height: proposal.height ?? .greatestFiniteMagnitude
        )
        return CGSize(
            width: min(intrinsicSize.width, proposedSize.width),
            height: min(intrinsicSize.height, proposedSize.height)
        )
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let textField = context.coordinator.textField
        context.coordinator.maxDigitCount = maxDigitCount
        context.coordinator.prefix = prefix
        context.coordinator.suffix = suffix
        textField.keyboardAppearance = appearance
        textField.placeholder = placeholder
        textField.keyboardType = format.keyaboardType
        textField.font = font
        textField.text = numberString.isEmpty ? "" : "\(prefix)\(numberString)\(suffix)"
        if isEditing, textField.isFirstResponder == false {
            textField.becomeFirstResponder()
        } else if !isEditing, textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        context.coordinator.textField
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            numberString: $numberString,
            maxDigitCount: maxDigitCount,
            prefix: prefix,
            suffix: suffix
        )
    }
}

@MainActor
fileprivate class InternalTextField: UITextField {
    private let fakeLabel = UILabel()
    
    override var intrinsicContentSize: CGSize {
        fakeLabel.font = font
        fakeLabel.text = text?.isEmpty == true ? placeholder : text
        return fakeLabel.intrinsicContentSize
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

@MainActor
class Coordinator: NSObject {
    @Binding var numberString: String
    var maxDigitCount: Int?
    var prefix: String
    var suffix: String
    
    lazy var textField: UITextField = {
        let textField = InternalTextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    init(
        numberString: Binding<String>,
        maxDigitCount: Int?,
        prefix: String,
        suffix: String
    ) {
        _numberString = numberString
        self.maxDigitCount = maxDigitCount
        self.prefix = prefix
        self.suffix = suffix
    }
    
    @objc func didChangeText(_ sender: UITextField) {
        numberString = textToNumberString()
    }
    
    private func textToNumberString() -> String {
        guard var text = textField.text else { return "" }
        if text.hasPrefix(prefix) {
            text = String(text.dropFirst(prefix.count))
            if text.hasSuffix(suffix) {
                text = String(text.dropLast(suffix.count))
            }
        }
        return text
    }
}

extension Coordinator: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string.isEmpty {
            return true
        }
        
        if string == "." {
            if textField.text == "" {
                textField.text = "\(prefix)0.\(suffix)"
                textField.sendActions(for: .editingChanged)
                return false
            } else if textField.text == "\(prefix)0\(suffix)" {
                return true
            } else if textToNumberString().contains(".") {
                return false
            } else if let maxDigitCount {
                return textToNumberString().count < maxDigitCount
            }
        }
        
        if string == "0" {
            if textField.text == "\(prefix)0\(suffix)" {
                return false
            }
        }
        
        if CharacterSet(charactersIn: string).isSubset(of: .decimalDigits) {
            if textField.text == "\(prefix)0\(suffix)" {
                textField.text = "\(prefix)\(string)\(suffix)"
                textField.sendActions(for: .editingChanged)
                return false
            } else if let maxDigitCount {
                return textToNumberString().replacingOccurrences(of: ".", with: "").count < maxDigitCount
            } else { 
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text,
              let lastPosition = textField.position(from: textField.beginningOfDocument, offset: text.count - suffix.count) else { return }
        textField.selectedTextRange = textField.textRange(from: lastPosition, to: lastPosition)
    }
}
