//
//  HaebitFilmInfoViewModel.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import Portolan

protocol HaebitFilmInfoViewModelDelegate: AnyObject {
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToDeleteFilm film: Film) async throws
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToUpdateFilm film: Film) async throws
}

@MainActor
final class HaebitFilmInfoViewModel: ObservableObject, MapInfoViewModelProtocol {
    private let film: Film
    @Published var coordinate: Coordinate?
    @Published var locationInfo: String?
    @Published var date: Date
    @Published var focalLength: FocalLengthValue
    @Published var iso: IsoValue
    @Published var shutterSpeed: ShutterSpeedValue
    @Published var aperture: ApertureValue
    @Published var memo: String
    
    var isEdited: Bool {
        film.date != date
        || film.coordinate != coordinate
        || film.focalLength != focalLength
        || film.iso != iso
        || film.shutterSpeed != shutterSpeed
        || film.aperture != aperture
        || film.memo != memo
    }
    
    weak var delegate: (any HaebitFilmInfoViewModelDelegate)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(film: Film) {
        self.film = film
        date = film.date
        coordinate = film.coordinate
        focalLength = film.focalLength
        iso = film.iso
        shutterSpeed = film.shutterSpeed
        aperture = film.aperture
        memo = film.memo
        bind()
    }
    
    private func bind() {
        $coordinate
            .sink { [weak self] coordinate in
                self?.updateLocationInfo(coordinate: coordinate)
            }
            .store(in: &cancellables)
    }
    
    private func updateLocationInfo(coordinate: Coordinate?) {
        guard let coordinate else {
            locationInfo = nil
            return
        }
        Task {
            locationInfo = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate)
        }
    }
    
    func didTapSave() {
        let updatedFilm = film.update(
            date: date,
            coordinate: coordinate,
            focalLength: focalLength,
            iso: iso,
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
        // TODO: Save updated film using logger
    }
    
    func undo() {
        date = film.date
        coordinate = film.coordinate
        focalLength = film.focalLength
        iso = film.iso
        shutterSpeed = film.shutterSpeed
        aperture = film.aperture
        memo = film.memo
    }
    
    func delete() async throws {
        try await delegate?.haebitFilmInfoViewModel(self, requestToDeleteFilm: film)
    }
}

extension Film {
    func update(
        date: Date,
        coordinate: Coordinate?,
        focalLength: FocalLengthValue,
        iso: IsoValue,
        shutterSpeed: ShutterSpeedValue,
        aperture: ApertureValue,
        memo: String
    ) -> Film {
        Film(
            id: self.id,
            date: date,
            coordinate: coordinate,
            image: self.image,
            focalLength: focalLength,
            iso: iso,
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
    }
}
