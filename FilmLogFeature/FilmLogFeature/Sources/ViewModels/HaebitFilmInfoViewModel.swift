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
import MapKit

@MainActor
protocol HaebitFilmInfoViewModelDelegate: AnyObject {
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToDeleteFilm film: Film) async throws
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToUpdateFilm film: Film) async throws
}

@MainActor
final class HaebitFilmInfoViewModel: ObservableObject, MapInfoViewModelProtocol {
    private let searchService = PortolanLocationSearchService()
    private let film: Film
    @Published var coordinate: Coordinate?
    @Published var searchQuery: String = ""
    @Published var searchResults: [MapSearchResult] = []
    @Published var searchResultSelection: MapSearchResult?
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
    private var searchTask: Task<Void, Never>?
    
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
        $searchQuery
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.search(query)
            }
            .store(in: &cancellables)
        
        $searchResultSelection
            .compactMap { $0?.coordinate }
            .assign(to: &$coordinate)
    }
    
    private func search(_ query: String) {
        searchTask?.cancel()
        searchTask = Task { searchResults = await searchService.search(query: query).map { $0.mapSearchResult } }
    }
    
    func didTapUndo() {
        date = film.date
        coordinate = film.coordinate
        focalLength = film.focalLength
        iso = film.iso
        shutterSpeed = film.shutterSpeed
        aperture = film.aperture
        memo = film.memo
    }
    
    func didTapDelete() async throws {
        try await delegate?.haebitFilmInfoViewModel(self, requestToDeleteFilm: film)
    }
    
    func didTapSave() async throws{
        let updatedFilm = film.update(
            date: date,
            coordinate: coordinate,
            focalLength: focalLength,
            iso: iso,
            shutterSpeed: shutterSpeed,
            aperture: aperture,
            memo: memo
        )
        try await delegate?.haebitFilmInfoViewModel(self, requestToUpdateFilm: updatedFilm)
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

extension PortolanLocation {
    var mapSearchResult: MapSearchResult {
        .init(
            name: name,
            address: address,
            coordinate: .init(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )!
        )
    }
}
