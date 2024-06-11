//
//  MemoView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

@MainActor
struct MemoView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    @State var placeholder: String
    let font: UIFont
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let proposedWidth = proposal.width ?? .zero
        let bestFitHeight = uiView.sizeThatFits(.init(width: proposedWidth, height: .greatestFiniteMagnitude)).height
        return .init(width: proposedWidth, height: bestFitHeight)
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
        context.coordinator.placeholderLabel.text = placeholder
        context.coordinator.placeholderLabel.font = font
        context.coordinator.placeholderLabel.isHidden = !text.isEmpty
        if isEditing, uiView.isFirstResponder == false {
            uiView.becomeFirstResponder()
        } else if !isEditing, uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    func makeUIView(context: Context) -> UITextView {
        context.coordinator.textView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing)
    }
    
    @MainActor
    class Coordinator: NSObject, UITextViewDelegate {
        let placeholderLabel = UILabel()
        lazy var textView: UITextView = {
            let textView = UITextView()
            textView.textAlignment = .justified
            textView.delegate = self
            textView.isEditable = true
            textView.isScrollEnabled = false
            textView.textContainer.lineBreakMode = .byWordWrapping
            textView.textContainer.lineFragmentPadding = .zero
            textView.textContainerInset = .zero
            return textView
        }()
        
        @Binding var text: String
        @Binding var isEditing: Bool
            
        init(text: Binding<String>, isEditing: Binding<Bool>) {
            self._text = text
            self._isEditing = isEditing
            super.init()
            setupPlaceholder()
        }
        
        private func setupPlaceholder() {
            placeholderLabel.textColor = .tertiaryLabel
            textView.addSubview(placeholderLabel)
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
                placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            ])
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            isEditing = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            isEditing = false
        }
    }
}

#Preview {
    @State var text = ""
    var placeholder = "Placeholder"
    return MemoView(text: $text, isEditing: .constant(true), placeholder: placeholder, font: .systemFont(ofSize: 14))
}

