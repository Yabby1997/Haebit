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
        guard let filmAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: FilmAnnotationView.reuseIdentifier) as? FilmAnnotationView else {
            return nil
        }
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            filmAnnotationView.viewModel = HaebitFilmLogPassiveViewModel(films: clusterAnnotation.memberAnnotations.compactMap { $0 as? FilmAnnotation }.map { $0.film } )
        } else if let annotation = annotation as? FilmAnnotation {
            filmAnnotationView.viewModel = HaebitFilmLogPassiveViewModel(films: [annotation.film])
            filmAnnotationView.clusteringIdentifier = FilmAnnotationView.clusteringIdentifier
        }
        return filmAnnotationView
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
