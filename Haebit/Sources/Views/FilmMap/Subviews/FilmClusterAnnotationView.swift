//
//  FilmClusterAnnotationView.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import MapKit
import SnapKit

final class FilmClusterAnnotationView: MKAnnotationView {
    private let frameView = UIImageView()
    private let imageView = UIImageView()
    private let label = UILabel()
    
    var films: [Film] {
        ((annotation as? MKClusterAnnotation)?.memberAnnotations ?? [])
            .compactMap { $0 as? FilmAnnotation }
            .map { $0.film }
            .sorted { $0.date > $1.date }
    }
    
    static let reuseIdentifier: String = "FilmClusterAnnotationViewReuseIdentifier"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        centerOffset = CGPoint(x: 0, y: -10)
        frame = CGRect(x: 0, y: 0, width: 80, height: 424.0 * 80.0 / 390.0)
        
        frameView.image = HaebitDevAsset.Assets.ektachromeFrame.image
        addSubview(frameView)
        frameView.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(frameView.snp.width).multipliedBy(424.0 / 390.0)
        }
        
        frameView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(2)
            make.width.equalTo(imageView.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .red
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = ""
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let firstFilm = films.first else { return }
        imageView.setDownSampledImage(at: firstFilm.image)
        label.text = "\(films.count)"
    }
}
