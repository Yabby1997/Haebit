//
//  FilmAnnotationView.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import MapKit
import SnapKit

final class FilmAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "FilmAnnotationViewReuseIdentifier"
    static let clusteringIdentifier = "FilmAnnotationViewClusteringIdentifier"
    
    private let label = UILabel()

    var frameView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = HaebitDevAsset.Assets.ektachromeFrame.image
        return imageView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var viewModel: (any HaebitFilmLogViewModelProtocol)? {
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
        label.text = ""
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        refresh()
    }
    
    private func refresh() {
        guard let viewModel, let film = viewModel.films[safe: viewModel.currentIndex] else { return }
        imageView.setDownSampledImage(at: film.image)
        label.text = "\(viewModel.films.count)"
    }
    
    private func setupViews() {
        centerOffset = CGPoint(x: 0, y: -10)
        frame = CGRect(x: 0, y: 0, width: 80, height: 424.0 * 80.0 / 390.0)
        
        addSubview(frameView)
        frameView.snp.makeConstraints { $0.center.width.height.equalToSuperview() }
        
        frameView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(2)
            make.width.equalTo(imageView.snp.height).multipliedBy(24.0 / 36.0)
        }
        
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .red
        frameView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel?.currentIndexPublisher
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &cancellables)
    }
}
