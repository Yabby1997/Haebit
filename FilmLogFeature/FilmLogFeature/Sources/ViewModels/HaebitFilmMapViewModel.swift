//
//  HaebitFilmMapViewModel.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/19/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import HaebitLogger
import HaebitUtil
import Portolan

@MainActor
final class HaebitFilmMapViewModel {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    private let preferenceProvider: LoggerPreferenceProvidable
    
    @Published private var films: [Film] = []
    @Published private var mainTitle: String = ""
    @Published private var isTitleUpdating = false
    @Published var currentLocation: Coordinate?
    @Published private(set) var perforationShape: PerforationShape = .ks
    var filmsPublisher: AnyPublisher<[Film], Never> { $films.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var mainTitlePublisher: AnyPublisher<String, Never> { $mainTitle.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var isTitleUpdatingPublisher: AnyPublisher<Bool, Never> { $isTitleUpdating.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var perforationShapePublisher: AnyPublisher<PerforationShape, Never> { preferenceProvider.perforationShapePublisher }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        logger: HaebitLogger,
        preferenceProvider: LoggerPreferenceProvidable
    ) {
        self.logger = logger
        self.preferenceProvider = preferenceProvider
        Task { await reload() }
        bind()
    }
    
    private func bind() {
        $currentLocation
            .sink { [weak self] _ in
                self?.isTitleUpdating = true
            }
            .store(in: &cancellables)
        
        $currentLocation
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] coordinate in
                self?.updateMainTitle(for: coordinate)
            }
            .store(in: &cancellables)
        
        preferenceProvider.perforationShapePublisher
            .assign(to: &$perforationShape)
    }
    
    func onAppear() {
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
    
    private func updateMainTitle(for coordinate: Coordinate) {
        Task {
            guard let representation = await PortolanGeocoder.shared.represent(for: coordinate.portolanCoordinate) else {
                mainTitle = ""
                isTitleUpdating = false
                return
            }
            mainTitle = representation
            isTitleUpdating = false
        }
    }
}

extension HaebitFilmMapViewModel: HaebitFilmAnnotationViewDelegate {
    func haebitFilmAnnotationView(_ view: HaebitFilmAnnotationView, requestToDeleteFilm film: Film) async throws {
        try FileManager().removeItem(at: film.image)
        try await logger.remove(log: film.id)
        await reload()
    }
    
    func haebitFilmAnnotationView(_ view: HaebitFilmAnnotationView, requestToUpdateFilm film: Film) async throws {
        try await logger.save(log: film.haebitLog)
        await reload()
    }
}
