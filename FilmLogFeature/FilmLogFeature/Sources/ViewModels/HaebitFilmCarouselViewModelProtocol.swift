//
//  HaebitFilmCarouselViewModelProtocol.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation

@MainActor
protocol HaebitFilmCarouselViewModelProtocol: HaebitFilmInfoViewModelDelegate {
    var films: [Film] { get }
    var currentIndex: Int { get set }
    var mainTitlePublisher: AnyPublisher<String, Never> { get }
    var subTitlePublisher: AnyPublisher<String, Never> { get }
    var isTitleUpdatingPublisher: AnyPublisher<Bool, Never> { get }
    var reloadCurrentIndexSignalPublisher: AnyPublisher<Void, Never> { get }
}
