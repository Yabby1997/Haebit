//
//  HaebitFilmMapViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 4/14/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import HaebitCommonModels
import MapKit
import SnapKit
import UIKit

final class HaebitFilmMapViewController: UIViewController {
    private let annotationID = "FilmAnnotationViewAnnotationIdentifier"
    private let clusterID = "FilmAnnotationViewClusterIdentifier"
    
    private let titleLabel: LoadingLabel = {
        let label = LoadingLabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
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
        mapView.register(HaebitFilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationID)
        mapView.register(HaebitFilmAnnotationView.self, forAnnotationViewWithReuseIdentifier: clusterID)
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

    private var snapshotAnnotationView: HaebitFilmAnnotationView?
    
    private let viewModel: HaebitFilmMapViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: HaebitFilmMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        viewModel.onAppear()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        view.backgroundColor = .black
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        mapView.layer.addSublayer(shadowLayer)
    }
    
    private func bind() {
        viewModel.filmsPublisher
            .map { $0.compactMap { FilmAnnotation(film: $0) } }
            .sink { [weak mapView] newAnnotations in
                guard let mapView else { return }
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(newAnnotations)
            }
            .store(in: &cancellables)
        
        viewModel.mainTitlePublisher
            .removeDuplicates()
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
        
        viewModel.isTitleUpdatingPublisher
            .sink { [weak self] isUpdating in
                self?.titleLabel.isLoading = isUpdating
            }
            .store(in: &cancellables)
    }
    
    func setRegionIfNeeded() {
        guard let currentLocation = viewModel.currentLocation else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: .init(
                    latitude: currentLocation.latitude,
                    longitude: currentLocation.longitude
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
           let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID, for: annotation) as? HaebitFilmAnnotationView {
            let films = [annotation.film].sorted { $0.date > $1.date }
            view.films = films
            view.clusteringIdentifier = clusterID
            return view
        } else if let cluster = annotation as? MKClusterAnnotation,
                  let view = mapView.dequeueReusableAnnotationView(withIdentifier: clusterID, for: annotation) as? HaebitFilmAnnotationView {
            let films = (cluster.memberAnnotations.compactMap { ($0 as? FilmAnnotation)?.film }).sorted { $0.date > $1.date }
            view.films = films
            view.clusteringIdentifier = nil
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let filmAnnotationView = (view as? HaebitFilmAnnotationView) else { return }
        snapshotAnnotationView = filmAnnotationView
        let carouselViewController = HaebitFilmCarouselViewController(viewModel: filmAnnotationView.viewModel)
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
