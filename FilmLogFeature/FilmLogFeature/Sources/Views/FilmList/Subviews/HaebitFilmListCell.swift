//
//  HaebitFilmListCell.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import SnapKit
import SwiftUI
import UIKit

final class HaebitFilmListCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier: String = "HaebitFilmListCell"
    
    // MARK: - Subviews
    
    lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    // MARK: - Initiailizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoView.image = nil
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        
        contentView.backgroundColor = .black
        
        guard let frameView = UIHostingController(rootView: Frame135()).view else { return }
        frameView.backgroundColor = .black
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubview(photoView)
        photoView.backgroundColor = .black
        photoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(24.0 / 35.0)
            make.height.equalTo(contentView.snp.width).multipliedBy(36.0 / 35.0)
        }
    }
}
