//
//  HaebitFilmAnnotationView.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import MapKit
import SnapKit

final class HaebitFilmAnnotationView: MKAnnotationView {
    var frameView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FilmLogFeatureAsset.frameBH.image
        return imageView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let countBadge = CountBadge()
    
    var viewModel: HaebitFilmAnnotationViewModel? {
        didSet {
            cancellables = []
            bind()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        countBadge.count = .zero
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        refresh()
    }
    
    private func refresh() {
        guard let viewModel, let film = viewModel.films[safe: viewModel.currentIndex] else { return }
        imageView.setDownSampledImage(at: film.image)
        countBadge.count = UInt(viewModel.films.count)
    }
    
    private func setupViews() {
        centerOffset = CGPoint(x: 0, y: -10)
        frame = CGRect(x: 0, y: 0, width: 70, height: 76)
        
        addSubview(frameView)
        frameView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(76)
        }
        
        frameView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalTo(48)
        }
        
        frameView.addSubview(countBadge)
        countBadge.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(countBadge.minimumSize / 2.0)
            make.centerY.equalTo(frameView.snp.top)
        }
    }
    
    private func bind() {
        viewModel?.currentFilmPublisher
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &cancellables)
    }
}
