//
//  CountBadge.swift
//  HaebitDev
//
//  Created by Seunghun on 4/20/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

final class CountBadge: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    var minimumSize: CGFloat = 20 {
        didSet { updateMinimumSize() }
    }
    
    var minCount: UInt = 2
    var maxCount: UInt = 999
    var count: UInt = .zero {
        didSet {
            label.text = count > maxCount ? "\(maxCount)+" : "\(count)"
            isHidden = count > maxCount ? (maxCount < 2) : (count < 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
    private func setupViews() {
        backgroundColor = .red
        clipsToBounds = true
        
        updateMinimumSize()
    
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func updateMinimumSize() {
        snp.remakeConstraints { make in
            make.width.height.greaterThanOrEqualTo(minimumSize)
        }
    }
}
