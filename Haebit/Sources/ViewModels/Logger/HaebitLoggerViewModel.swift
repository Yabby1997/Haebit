//
//  HaebitLoggerViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 2/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger
import Portolan
import Combine

final class HaebitLoggerViewModel: ObservableObject {
    private let logger: HaebitLogger
    @Published var films: [Film] = []
    @Published var currentIndex: Int = .zero
    var nextIndex: Int?
    @Published var currentFilmAddress: String?
    @Published var currentFilmTime: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    var currentFilm: AnyPublisher<Film, Never> {
        $currentIndex
            .compactMap { [weak self] index in
                self?.films[safe: index]
            }
            .eraseToAnyPublisher()
    }
    
    init(logger: HaebitLogger) {
        self.logger = logger
        bind()
    }
    
    private func bind() {
        currentFilm
            .sink { [weak self] film in
                self?.setAddress(film)
                self?.setTime(film)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        Task {
            do {
                let logs = try await logger.logs().sorted { $0.date > $1.date }.map { $0.film }
                Task { @MainActor [weak self] in
                    self?.films = logs.sorted { $0.date > $1.date }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setAddress(_ film: Film) {
        guard let coordinate = film.coordinate else { return }
        Task { @MainActor in
            currentFilmAddress = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate)
        }
    }
    
    private func setTime(_ film: Film) {
        currentFilmTime = DateFormatter.localizedString(from: film.date, dateStyle: .medium, timeStyle: .short)
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
