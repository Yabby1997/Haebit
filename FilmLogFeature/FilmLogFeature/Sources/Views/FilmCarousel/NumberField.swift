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
    let prefix: String
    let suffix: String
    let placeholder: String
    let font: UIFont
    let appearance: UIKeyboardAppearance
    
    init(
        numberString: Binding<String>,
        isEditing: Binding<Bool>,
        format: Format,
        prefix: String = "",
        suffix: String = "",
        placeholder: String = "",
        font: UIFont = .systemFont(ofSize: 20),
        appearance: UIKeyboardAppearance = .default
    ) {
        _numberString = numberString
        _isEditing = isEditing
        self.format = format
        self.prefix = prefix
        self.suffix = suffix
        self.placeholder = placeholder
        self.font = font
        self.appearance = appearance
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        uiView.intrinsicContentSize
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let textField = context.coordinator.textField
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
        Coordinator(numberString: $numberString, format: format, prefix: prefix, suffix: suffix)
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
        switch action {
        case #selector(UIResponderStandardEditActions.copy), #selector(UIResponderStandardEditActions.cut):
            return super.canPerformAction(action, withSender: sender)
        default:
            return false
        }
    }
}

@MainActor
class Coordinator: NSObject {
    @Binding var numberString: String
    let format: NumberField.Format
    var prefix: String
    var suffix: String
    
    lazy var textField: UITextField = {
        let textField = InternalTextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        return textField
    }()
    
    init(numberString: Binding<String>, format: NumberField.Format, prefix: String, suffix: String) {
        _numberString = numberString
        self.format = format
        self.prefix = prefix
        self.suffix = suffix
    }
    
    @objc func didChangeText(_ sender: UITextField) {
        guard var newValue = textField.text else { return }
        if newValue.hasPrefix(prefix) {
            newValue = String(newValue.dropFirst(prefix.count))
            if newValue.hasSuffix(suffix) {
                newValue = String(newValue.dropLast(suffix.count))
            }
        }
        numberString = newValue
    }
    
    func updateCursor() {
        guard let text = textField.text,
              let startPosition = textField.selectedTextRange?.start,
              let endPosition = textField.selectedTextRange?.end else { return }
        let lastEditableOffset = text.count - suffix.count
        let newStartOffsetFromBeginning = max(prefix.count, min(textField.offset(from: textField.beginningOfDocument, to: startPosition), lastEditableOffset))
        let newEndOffsetFromBeginning = max(prefix.count, min(textField.offset(from: textField.beginningOfDocument, to: endPosition), lastEditableOffset))
        guard let newStartPosition = textField.position(from: textField.beginningOfDocument, offset: newStartOffsetFromBeginning),
              let newEndPosition = textField.position(from: textField.beginningOfDocument, offset: newEndOffsetFromBeginning) else { return }
        textField.selectedTextRange = textField.textRange(from: newStartPosition, to: newEndPosition)
    }
}

extension Coordinator: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer { updateCursor() }
        
        // Prevent prefix from being removed.
        if range.location + range.length == prefix.count, string == "" {
            return false
        }
        
        // Case where initial input is 0 or decimal point
        if numberString.isEmpty, (string == "0" || string == ".") {
            switch format {
            case .integer:
                return false
            case .decimal:
                numberString = "0."
                return true
            }
        }
        
        // Case where already have decimal point
        if numberString.contains("."), string == "." {
            return false
        }
        
        // Otherwise, unless it's number, it's alright
        return CharacterSet(charactersIn: string).isSubset(of: CharacterSet(charactersIn: "0123456789"))
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCursor()
    }
}
