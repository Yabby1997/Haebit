//
//  TitleLabel.swift
//  HaebitDev
//
//  Created by Seunghun on 5/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

final class TitleLabel: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var loadingView: UIView = {
        let view = UIHostingController(rootView: LoadingView(count: 3, duration: 0.8, delay: 0.2)).view!
        view.backgroundColor = .clear
        return view
    }()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var isLoading = false {
        didSet {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                self.loadingView.alpha = self.isLoading ? 1.0 : .zero
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(loadingView)
        loadingView.snp.makeConstraints { $0.width.equalTo(40) }
        
        stackView.addArrangedSubview(UIView())
    }
}
