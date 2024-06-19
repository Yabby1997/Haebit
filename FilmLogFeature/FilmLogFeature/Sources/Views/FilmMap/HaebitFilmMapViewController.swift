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

    private var selectedAnnotationView: HaebitFilmAnnotationView?
    @Published private var isMapInitiallyRendered = false
    @Published private var isAppearing = false
    
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
        selectedAnnotationView?.onAppear()
        isAppearing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setTitlePosition(.center)
        navigationItem.titleView = nil
        isAppearing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        overrideUserInterfaceStyle = .light
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        view.backgroundColor = .black
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        mapView.layer.addSublayer(shadowLayer)
    }
    
    private func bind() {
        viewModel.filmsPublisher.combineLatest($isMapInitiallyRendered, $isAppearing)
            .filter { $1 && $2 }
            .compactMap { [weak self] films, _, _ -> [FilmAnnotation]? in
                guard let self else { return nil }
                return mapView.annotations.compactMap { $0 as? FilmAnnotation }.filter { !films.contains($0.film) }
            }
            .filter { $0.count > .zero }
            .sink { [weak self] annotations in
                self?.mapView.removeAnnotations(annotations)
            }
            .store(in: &cancellables)

        viewModel.filmsPublisher.combineLatest($isMapInitiallyRendered, $isAppearing)
            .filter { $1 && $2 }
            .compactMap { [weak self] films, _, _ -> [FilmAnnotation]? in
                guard let self else { return nil }
                let existingFilms = mapView.annotations.compactMap { ($0 as? FilmAnnotation)?.film }
                return films.filter { !existingFilms.contains($0) }.compactMap { FilmAnnotation(film: $0) }
            }
            .filter { $0.count > .zero }
            .sink { [weak self] annotations in
                self?.mapView.addAnnotations(annotations)
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
                center: currentLocation.clLocationCoordinate2D,
                latitudinalMeters: 100_000,
                longitudinalMeters: 100_000
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
            view.delegate = viewModel
            view.clusteringIdentifier = clusterID
            return view
        } else if let cluster = annotation as? MKClusterAnnotation,
                  let view = mapView.dequeueReusableAnnotationView(withIdentifier: clusterID, for: annotation) as? HaebitFilmAnnotationView {
            let films = (cluster.memberAnnotations.compactMap { ($0 as? FilmAnnotation)?.film }).sorted { $0.date > $1.date }
            view.films = films
            view.delegate = viewModel
            view.clusteringIdentifier = nil
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let filmAnnotationView = (view as? HaebitFilmAnnotationView) else { return }
        selectedAnnotationView = filmAnnotationView
        let carouselViewController = HaebitFilmCarouselViewController(viewModel: filmAnnotationView.viewModel)
        navigationController?.pushViewController(carouselViewController, animated: true)
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        viewModel.currentLocation = mapView.region.center.coordinate
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        guard isMapInitiallyRendered == false else { return }
        isMapInitiallyRendered = fullyRendered
    }
}

extension HaebitFilmMapViewController: HaebitNavigationAnimatorSnapshotProvidable {
    func viewForTransition() -> UIView? {
        selectedAnnotationView?.imageView
    }
    
    func regionForTransition() -> CGRect? {
        guard let selectedAnnotationView else { return nil }
        return mapView.convert(
            selectedAnnotationView.convert(
                selectedAnnotationView.frameView.convert(
                    selectedAnnotationView.imageView.frame,
                    to: selectedAnnotationView
                ),
                to: mapView
            ),
            to: view
        )
    }
    
    func blurIntensityForSnapshot() -> CGFloat {
        0.02
    }
}

extension CLLocationCoordinate2D {
    var coordinate: Coordinate? {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Film {
    fileprivate static func == (lhs: Film, rhs: Film) -> Bool {
        lhs.id == rhs.id && lhs.coordinate == rhs.coordinate
    }
}
