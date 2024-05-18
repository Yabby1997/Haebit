//
//  HaebitFilmLogViewModel.swift
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

@MainActor
public final class HaebitFilmLogViewModel: HaebitFilmLogViewModelProtocol {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    
    @Published public var mainTitle: String = ""
    @Published public var subTitle: String = ""
    @Published public var films: [Film] = []
    @Published public var currentIndex: Int = .zero
    @Published public var currentLocation: Coordinate?
    @Published public var isTitleUpdating = false
    @Published private var currentFilm: Film?
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(logger: HaebitLogger) {
        self.logger = logger
        bind()
    }
    
    private func bind() {
        $currentIndex
            .compactMap { [weak self] index in
                self?.films[safe: index]
            }
            .sink { [weak self] film in
                self?.updateSubtitle(for: film)
            }
            .store(in: &cancellables)
        
        $currentIndex
            .map { [weak self] index in
                self?.films[safe: index]
            }
            .assign(to: &$currentFilm)
        
        $currentFilm
            .compactMap { $0?.coordinate }
            .assign(to: &$currentLocation)
        
        $currentLocation
            .filter { $0 == nil }
            .sink { [weak self] _ in
                self?.mainTitle = ""
            }
            .store(in: &cancellables)
        
        $currentLocation
            .compactMap { $0 }
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] coordinate in
                self?.updateMainTitle(for: coordinate)
            }
            .store(in: &cancellables)
        
        $currentLocation
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.isTitleUpdating = true
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
    
    private func updateSubtitle(for film: Film) {
        let formattedDate = dateFormatter.formatDate(from: film.date)
        let formattedTime = dateFormatter.formatTime(from: film.date)
        subTitle = formattedDate + " " + formattedTime
    }
    
    private func updateMainTitle(for coordinate: Coordinate) {
        Task {
            guard let representation = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate) else {
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
