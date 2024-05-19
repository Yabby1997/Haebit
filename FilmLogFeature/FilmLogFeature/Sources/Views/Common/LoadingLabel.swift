//
//  LoadingLabel.swift
//  HaebitDev
//
//  Created by Seunghun on 5/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

final class LoadingLabel: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var loadingView: UIView = {
        let view = UIHostingController(rootView: LoadingView(count: 3, duration: 0.8, delay: 0.2)).view!
        view.backgroundColor = .clear
        return view
    }()
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var textColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { 
            label.textAlignment = newValue
            updateLoadingView()
        }
    }

    var isLoading = false {
        didSet {
            label.isHidden = isLoading
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                self.loadingView.alpha = self.isLoading ? 1.0 : .zero
            }
        }
    }
    
    var font: UIFont {
        get { label.font }
        set {
            label.font = newValue
            updateLoadingView()
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
        addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
    
    private func updateLoadingView() {
        loadingView.snp.remakeConstraints { make in
            switch textAlignment {
            case .left, .justified:
                make.left.top.bottom.equalToSuperview()
            case .right:
                make.right.top.bottom.equalToSuperview()
            case .center:
                make.center.equalToSuperview()
            case .natural:
                make.leading.top.bottom.equalToSuperview()
            @unknown default:
                make.center.equalToSuperview()
            }
            make.width.equalTo(font.pointSize * 2.5)
            make.height.equalTo(font.pointSize)
        }
    }
}
