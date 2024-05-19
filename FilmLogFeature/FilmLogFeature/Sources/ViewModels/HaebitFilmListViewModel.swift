//
//  HaebitFilmListViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 2/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import HaebitLogger
import HaebitUtil
import Portolan

public final class HaebitFilmListViewModel: HaebitFilmCarouselViewModelProtocol {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    
    @Published private var mainTitle: String = ""
    @Published private var subTitle: String = ""
    @Published private var isTitleUpdating = false
    @Published private var currentFilm: Film?
    @Published private(set) var films: [Film] = []
    @Published var currentIndex: Int = .zero
    var mainTitlePublisher: AnyPublisher<String, Never> { $mainTitle.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var subTitlePublisher: AnyPublisher<String, Never> { $subTitle.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var filmsPublisher: AnyPublisher<[Film], Never> { $films.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var isTitleUpdatingPublisher: AnyPublisher<Bool, Never> { $isTitleUpdating.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(logger: HaebitLogger) {
        self.logger = logger
        bind()
    }
    
    private func bind() {
        $currentIndex
            .map { [weak self] index in
                self?.films[safe: index]
            }
            .assign(to: &$currentFilm)
        
        $currentFilm
            .removeDuplicates()
            .sink { [weak self] film in
                guard let self, let film else { return }
                isTitleUpdating = true
                if film.coordinate == nil {
                    mainTitle = dateFormatter.formatDate(from: film.date)
                    subTitle = dateFormatter.formatTime(from: film.date)
                    isTitleUpdating = false
                } else {
                    subTitle = dateFormatter.formatDate(from: film.date) + " " + dateFormatter.formatTime(from: film.date)
                }
            }
            .store(in: &cancellables)
        
        $currentFilm
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] film in
                self?.updateTitle(for: film)
            }
            .store(in: &cancellables)
    }
    
    public func onAppear() {
        reload()
    }
    
    private func reload() {
        Task {
            do {
                let logs = try await logger.logs().sorted { $0.date > $1.date }.compactMap { $0.film }
                films = logs.sorted { $0.date > $1.date }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateTitle(for film: Film?) {
        guard let film else { return }
        Task {
            guard let coordinate = film.coordinate?.portolanCoordinate,
                  let representation = await PortolanGeocoder.shared.represent(for: coordinate) else {
                mainTitle = dateFormatter.formatDate(from: film.date)
                subTitle = dateFormatter.formatTime(from: film.date)
                isTitleUpdating = false
                return
            }
            mainTitle = representation
            isTitleUpdating = false
        }
    }
}

extension HaebitLog {
    var film: Film? {
        guard let shutterSpeed = ShutterSpeedValue(denominator: shutterSpeed) else {
            return nil
        }
        return .init(
            id: id,
            date: date,
            coordinate: coordinate?.coordinate,
            image: URL.homeDirectory.appending(path: image),
            focalLength: FocalLengthValue(value: Int(focalLength)),
            iso: IsoValue(iso: Int(iso)),
            shutterSpeed: shutterSpeed,
            aperture: ApertureValue(value: aperture),
            memo: memo
        )
    }
}

extension HaebitCoordinate {
    var coordinate: Coordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

extension Coordinate {
    var portolanCoordinate: PortolanCoordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}
