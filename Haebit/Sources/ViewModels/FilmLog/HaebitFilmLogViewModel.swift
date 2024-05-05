//
//  HaebitFilmLogViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 2/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitLogger
import HaebitUtil
import Portolan

final class HaebitFilmLogViewModel: HaebitFilmLogViewModelProtocol {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    
    @Published var mainTitle: String = ""
    @Published var subTitle: String = ""
    @Published var films: [Film] = []
    @Published var currentIndex: Int = .zero
    @Published var currentLocation: Coordinate?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(logger: HaebitLogger, currentLocation: Coordinate?) {
        self.logger = logger
        self.currentLocation = currentLocation
        bind()
        reload()
    }
    
    private func bind() {
        $currentIndex
            .compactMap { [weak self] index in
                self?.films[safe: index]
            }
            .sink { [weak self] film in
                self?.updateTitle(for: film)
            }
            .store(in: &cancellables)
        
        $currentLocation
            .compactMap { $0 }
            .removeDuplicates()
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [weak self] coordinate in
                self?.updateTitle(for: coordinate)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        if let currentLocation {
            updateTitle(for: currentLocation)
        }
    }
    
    private func reload() {
        Task {
            do {
                let logs = try await logger.logs().sorted { $0.date > $1.date }.map { $0.film }
                films = logs.sorted { $0.date > $1.date }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateTitle(for film: Film) {
        Task {
            var coordinateRepresentation: String?
            if let coordinate = film.coordinate {
                coordinateRepresentation = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate)
            }
            
            let formattedDate = dateFormatter.formatDate(from: film.date)
            let formattedTime = dateFormatter.formatTime(from: film.date)
            if let coordinateRepresentation {
                mainTitle = coordinateRepresentation
                subTitle = formattedDate + " " + formattedTime
            } else {
                mainTitle = formattedDate
                subTitle = formattedTime
            }
        }
    }
    
    private func updateTitle(for coordinate: Coordinate) {
        Task {
            guard let representation = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate) else {
                return
            }
            mainTitle = representation
        }
    }
}

extension HaebitLog {
    var film: Film {
        .init(
            id: id,
            date: date,
            coordinate: coordinate?.coordinate,
            image: URL.homeDirectory.appending(path: image),
            focalLength: FocalLengthValue(value: Int(focalLength)),
            iso: IsoValue(iso: Int(iso)),
            shutterSpeed: ShutterSpeedValue(denominator: shutterSpeed),
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
