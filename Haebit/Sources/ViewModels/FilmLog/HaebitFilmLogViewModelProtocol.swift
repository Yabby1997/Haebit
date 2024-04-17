//
//  HaebitFilmLogViewModelProtocol.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import Combine

protocol HaebitFilmLogViewModelProtocol: ObservableObject {
    var mainTitle: String { get set }
    var subTitle: String { get set }
    var films: [Film] { get set }
    var currentIndex: Int { get set }
    func onAppear()
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
}
