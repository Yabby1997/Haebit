//
//  NumericTextView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

@MainActor
fileprivate struct NumericText: View {
    @StateObject var viewModel: SubtitleLabelViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.text)
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.leading)
                .animation(.easeInOut, value: viewModel.text)
                .contentTransition(.numericText())
            Spacer()
        }
    }
}

fileprivate final class SubtitleLabelViewModel: ObservableObject {
    @Published var text: String = ""
}

@MainActor
final class SubtitleLabel: UIView {
    private let viewModel = SubtitleLabelViewModel()
    var text: String {
        get { viewModel.text }
        set { viewModel.text = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        guard let view = UIHostingController(rootView: NumericText(viewModel: self.viewModel)).view else { return }
        view.backgroundColor = .clear
        addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
