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
    
    private let titleLabel = TitleLabel()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.register(FilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationID)
        mapView.register(FilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: clusterID)
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private lazy var shadowLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.2]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: .zero, y: 1.0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        return gradientLayer
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.onAppear()
        navigationController?.setTitlePosition(.left)
        navigationItem.titleView = titleLabel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setTitlePosition(.center)
        navigationItem.titleView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        view.backgroundColor = .black
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        mapView.layer.addSublayer(shadowLayer)
        
        setInitialRegionIfNeeded()
    }
    
    private func bind() {
        viewModel.$films
            .map { $0.compactMap { FilmAnnotation(film: $0) } }
            .sink { [weak self] annotations in
                self?.mapView.addAnnotations(annotations)
            }
            .store(in: &cancellables)
        
        viewModel.$mainTitle
            .removeDuplicates()
            .sink { [weak self] title in
                self?.titleLabel.title = title
            }
            .store(in: &cancellables)
        
        viewModel.$isTitleUpdating
            .sink { [weak self] isUpdating in
                self?.titleLabel.isLoading = isUpdating
            }
            .store(in: &cancellables)
    }
    
    private func setInitialRegionIfNeeded() {
        guard let initialLocation = viewModel.currentLocation else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: .init(
                    latitude: initialLocation.latitude,
                    longitude: initialLocation.longitude
                ),
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
    }
    
    @objc private func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        viewModel.currentLocation = mapView.region.center.coordinate
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

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}
