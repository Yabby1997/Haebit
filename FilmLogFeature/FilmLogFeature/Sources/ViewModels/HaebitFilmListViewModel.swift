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
    
    @Published private var reloadCurrentIndexSignal: Void?
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
    var reloadCurrentIndexSignalPublisher: AnyPublisher<Void, Never> {
        $reloadCurrentIndexSignal
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(logger: HaebitLogger) {
        self.logger = logger
        Task { await reload() }
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
                guard let self else { return }
                if let film {
                    isTitleUpdating = true
                    if film.coordinate == nil {
                        mainTitle = dateFormatter.formatDate(from: film.date)
                        subTitle = dateFormatter.formatTime(from: film.date)
                        isTitleUpdating = false
                    } else {
                        subTitle = dateFormatter.formatDate(from: film.date) + " " + dateFormatter.formatTime(from: film.date)
                    }
                } else {
                    isTitleUpdating = false
                    mainTitle = ""
                    subTitle = ""
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
        Task {
            await reload()
        }
    }
    
    private func reload() async {
        do {
            let logs = try await logger.logs().sorted { $0.date > $1.date }.compactMap { $0.film }
            films = logs.sorted { $0.date > $1.date }
        } catch {
            print(error.localizedDescription)
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
    
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToDeleteFilm film: Film) async throws {
        try FileManager().removeItem(at: film.image)
        try await logger.remove(log: film.id)
        await reload()
        currentIndex = currentIndex < films.count ? currentIndex : .zero
        reloadCurrentIndexSignal = ()
        reloadCurrentIndexSignal = nil
    }
    
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToUpdateFilm film: Film) async throws {
        try await logger.save(log: film.haebitLog)
        await reload()
        reloadCurrentIndexSignal = ()
        reloadCurrentIndexSignal = nil
    }
}

extension Film {
    var haebitLog: HaebitLog {
        var haebitCoordinate: HaebitCoordinate?
        if let coordinate {
            haebitCoordinate = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
        return .init(
            id: id,
            date: date,
            coordinate: haebitCoordinate,
            image: image.path.replacingOccurrences(of: URL.homeDirectory.path + "/", with: ""),
            focalLength: focalLength.value,
            iso: iso.value,
            shutterSpeed: HaebitShutterSpeed(
                numerator: shutterSpeed.numerator,
                denominator: shutterSpeed.denominator
            ),
            aperture: aperture.value,
            memo: memo
        )
    }
}

extension HaebitLog {
    var film: Film? {
        guard let focalLength = FocalLengthValue(focalLength),
              let iso = IsoValue(iso),
              let shutterSpeed = ShutterSpeedValue(numerator: shutterSpeed.numerator, denominator: shutterSpeed.denominator),
              let aperture = ApertureValue(aperture) else {
            return nil
        }
        return .init(
            id: id,
            date: date,
            coordinate: coordinate?.coordinate,
            image: URL.homeDirectory.appending(path: image),
            focalLength: focalLength,
            iso: iso,
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
    }
}

extension HaebitCoordinate {
    var coordinate: Coordinate? {
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
