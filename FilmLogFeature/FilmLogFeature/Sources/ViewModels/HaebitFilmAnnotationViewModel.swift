//
//  HaebitFilmAnnotationViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import HaebitLogger
import HaebitUtil
import Portolan

protocol HaebitFilmAnnotationViewModelDelegate: AnyObject {
    func haebitFilmAnnotationViewModel(_ viewModel: HaebitFilmAnnotationViewModel, requestToDeleteFilm film: Film) async throws
    func haebitFilmAnnotationViewModel(_ viewModel: HaebitFilmAnnotationViewModel, requestToUpdateFilm film: Film) async throws
}

@MainActor
final class HaebitFilmAnnotationViewModel: HaebitFilmCarouselViewModelProtocol {
    private let dateFormatter = HaebitDateFormatter()
    
    @Published private var mainTitle: String = ""
    @Published private var subTitle: String = ""
    @Published private var currentLocation: Coordinate?
    @Published private var isTitleUpdating = false
    @Published private var currentFilm: Film?
    @Published var films: [Film] = []
    @Published var currentIndex: Int = .zero
    var isReloadNeeded = false
    var currentFilmPublisher: AnyPublisher<Film?, Never> { $currentFilm.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var mainTitlePublisher: AnyPublisher<String, Never> { $mainTitle.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var subTitlePublisher: AnyPublisher<String, Never> { $subTitle.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    var isTitleUpdatingPublisher: AnyPublisher<Bool, Never> { $isTitleUpdating.receive(on: DispatchQueue.main).eraseToAnyPublisher() }
    
    private var cancellables: Set<AnyCancellable> = []
    
    weak var delegate: HaebitFilmAnnotationViewModelDelegate?
    
    func onAppear() {
        bind()
    }
    
    func onDisappear() {
        cancellables = []
    }
    
    private func bind() {
        $films.combineLatest($currentIndex)
            .map { films, index in
                films[safe: index]
            }
            .removeDuplicates()
            .assign(to: &$currentFilm)
        
        $currentFilm
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
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] film in
                self?.updateTitle(for: film)
            }
            .store(in: &cancellables)
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
        try await delegate?.haebitFilmAnnotationViewModel(self, requestToDeleteFilm: film)
        films.removeAll { $0.id == film.id }
        currentIndex = currentIndex < films.count ? currentIndex : .zero
        isReloadNeeded = true
    }
    
    func haebitFilmInfoViewModel(_ viewModel: HaebitFilmInfoViewModel, requestToUpdateFilm film: Film) async throws {
        try await delegate?.haebitFilmAnnotationViewModel(self, requestToUpdateFilm: film)
        if let index = (films.firstIndex { $0.id == film.id }) {
            films[index] = film
        }
        isReloadNeeded = true
    }
}
