//
//  HaebitFilmLogViewModelProtocol.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import Combine

@MainActor
protocol HaebitFilmLogViewModelProtocol: ObservableObject {
    var mainTitle: String { get set }
    var subTitle: String { get set }
    var films: [Film] { get set }
    var currentIndex: Int { get set }
    var currentLocation: Coordinate? { get set }
    var isTitleUpdating: Bool  { get set }
}

extension HaebitFilmLogViewModelProtocol {
    var mainTitlePublisher: AnyPublisher<String, Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.mainTitle }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var subTitlePublisher: AnyPublisher<String, Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.subTitle }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var filmsPublisher: AnyPublisher<[Film], Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.films }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var currentIndexPublisher: AnyPublisher<Int, Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.currentIndex }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var currentLocationPublisher: AnyPublisher<Coordinate, Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.currentLocation }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var isTitleUpdatingPublisher: AnyPublisher<Bool, Never> {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.isTitleUpdating }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
