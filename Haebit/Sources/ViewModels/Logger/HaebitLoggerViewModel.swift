//
//  HaebitLoggerViewModel.swift
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

final class HaebitLoggerViewModel: ObservableObject {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    
    @Published var mainTitle: String = ""
    @Published var subTitle: String = ""
    @Published var films: [Film] = []
    @Published var currentIndex: Int = .zero
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(logger: HaebitLogger) {
        self.logger = logger
        bind()
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
    
    private func updateTitle(for film: Film) {
        Task { @MainActor in
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
