//
//  HaebitFilmListCell.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class HaebitFilmListCell: UICollectionViewCell {
    
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
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoView.image = nil
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        guard let bgView = UIHostingController(rootView: Frame135()).view else { return }
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 24.0 / 35.0),
            photoView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 36.0 / 35.0),
        ])
    }
    
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.photoView, duration: 0.5, options: .transitionCrossDissolve) {
                self.photoView.image = image
            }
        }
    }
}
