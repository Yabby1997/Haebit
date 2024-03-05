//
//  HaebitFilmViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import UIKit
import PhotosUI
import SnapKit

class HaebitFilmViewController: UIViewController {
    
    // MARK: - Subviews
    
    private(set) lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(url: film.image)
        return imageView
    }()
    
    private lazy var shadowLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.15]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        return gradientLayer
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .italicSystemFont(ofSize: 12)
        label.text = "\(film.aperture.description) \(film.shutterSpeed.description) ISO\(film.iso.description) \(film.focalLength.title)"
        label.textAlignment = .center
        return label
    }()
    
    private var isPresenting = false
    private let maximumHeight = 400.0
    
    // MARK: - Properties
    
    private var film: Film
    private(set) var index: Int
    
    // MARK: - Initizliers
    
    init(film: Film, index: Int) {
        self.film = film
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.center.leading.trailing.equalToSuperview()
            make.height.equalTo(photoView.snp.width).multipliedBy(3.0 / 2.0)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        view.layer.addSublayer(shadowLayer)
    }
}
