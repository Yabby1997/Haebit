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
        mapView.register(FilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: FilmAnnotationView.reuseIdentifier)
        mapView.register(FilmClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: FilmClusterAnnotationView.reuseIdentifier)
        mapView.showsScale = true
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
            .map { $0.compactMap { FilmAnnotation(film: $0) } }
            .sink { [weak self] annotations in
                self?.mapView.addAnnotations(annotations)
            }
            .store(in: &cancellables)
    }
}

extension HaebitFilmMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: FilmClusterAnnotationView.reuseIdentifier)
            clusterView?.annotation = clusterAnnotation
            return clusterView
        } else if let annotation = annotation as? FilmAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: FilmAnnotationView.reuseIdentifier) as? FilmAnnotationView
            annotationView?.clusteringIdentifier = FilmAnnotationView.clusteringIdentifier
            annotationView?.annotation = annotation
            return annotationView
        }
        return nil
    }
}
