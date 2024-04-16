//
//  FilmAnnotationView.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import MapKit
import SnapKit

final class FilmAnnotationView: MKAnnotationView {
    private let frameView = UIImageView()
    private let imageView = UIImageView()
    
    var film: Film? {
        (annotation as? FilmAnnotation)?.film
    }
    
    static let reuseIdentifier = "FilmAnnotationViewReuseIdentifier"
    static let clusteringIdentifier = "FilmAnnotationViewClusteringIdentifier"
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let film else { return }
        imageView.setDownSampledImage(at: film.image)
    }
}
