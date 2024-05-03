//
//  HaebitFilmMapViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import MapKit
import SnapKit
import UIKit

final class HaebitFilmMapViewController: UIViewController {
    private let annotationID = "FilmAnnotationViewAnnotationIdentifier"
    private let clusterID = "FilmAnnotationViewClusterIdentifier"
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.register(FilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationID)
        mapView.register(FilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: clusterID)
        return mapView
    }()

    private var snapshotAnnotationView: FilmAnnotationView?
    
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
        if let annotation = annotation as? FilmAnnotation,
           let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID, for: annotation) as? FilmAnnotationView {
            let films = [annotation.film]
            view.viewModel = HaebitFilmLogPassiveViewModel(films: films)
            view.clusteringIdentifier = clusterID
            return view
        } else if let cluster = annotation as? MKClusterAnnotation,
           let view = mapView.dequeueReusableAnnotationView(withIdentifier: clusterID, for: annotation) as? FilmAnnotationView {
            let films = (cluster.memberAnnotations.compactMap { ($0 as? FilmAnnotation)?.film })
            view.viewModel = HaebitFilmLogPassiveViewModel(films: films)
            view.clusteringIdentifier = nil
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let filmAnnotationView = (view as? FilmAnnotationView),
              let viewModel = filmAnnotationView.viewModel else { return }
        snapshotAnnotationView = filmAnnotationView
        let carouselViewController = HaebitFilmCarouselViewController(viewModel: viewModel)
        navigationController?.pushViewController(carouselViewController, animated: true)
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}

extension HaebitFilmMapViewController: HaebitNavigationAnimatorSnapshotProvidable {
    func viewForTransition() -> UIView? {
        snapshotAnnotationView?.imageView
    }

    func regionForTransition() -> CGRect? {
        guard let snapshotAnnotationView else { return nil }
        return mapView.convert(
            snapshotAnnotationView.convert(
                snapshotAnnotationView.frameView.convert(
                    snapshotAnnotationView.imageView.frame,
                    to: snapshotAnnotationView
                ),
                to: mapView
            ),
            to: view
        )
    }
}
