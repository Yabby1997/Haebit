//
//  HaebitFilmMapViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import UIKit
import MapKit
import SnapKit

final class HaebitFilmMapViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private let viewModel: HaebitFilmLogViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: HaebitFilmLogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func bind() {
        viewModel.$films
            .map { films in
                films.compactMap { film -> MKPointAnnotation? in
                    guard let coordinate = film.coordinate?.clLocationCoordinate2D else { return nil }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    return annotation
                }
            }
            .sink { [weak self] annotations in
                self?.mapView.addAnnotations(annotations)
            }
            .store(in: &cancellables)
    }
}

extension HaebitFilmMapViewController: MKMapViewDelegate {
}

extension Coordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}
