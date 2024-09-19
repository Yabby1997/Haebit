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
    
    let frameView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .frameKS)
        return imageView
    }()
    
    let photoView: UIImageView = {
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
        super.prepareForReuse()
        photoView.image = nil
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubview(photoView)
        photoView.backgroundColor = .black
        photoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(24.0 / 35.0)
            make.height.equalTo(photoView.snp.width).multipliedBy(36.0 / 24.0)
        }
    }
}
