//
//  HaebitFilmLogPassiveViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitLogger
import HaebitUtil
import Portolan

final class HaebitFilmLogPassiveViewModel: HaebitFilmLogViewModelProtocol {
    private let logger: HaebitLogger
    private let dateFormatter = HaebitDateFormatter()
    
    @Published var mainTitle: String = ""
    @Published var subTitle: String = ""
    @Published var films: [Film] = []
    @Published var currentIndex: Int = .zero
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(films: [Film]) {
        self.logger = HaebitLogger(repository: MockHaebitLogRepository())
        self.films = films.sorted { $0.date > $1.date }
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
    
    func onAppear() {}
    
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
