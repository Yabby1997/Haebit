//
//  DemoHaebitFilmListViewModel.swift
//  Haebit
//
//  Created by Seunghun on 3/17/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

final class DemoHaebitFilmListViewModel: HaebitFilmListViewModelProtocol {
    var mainTitle: String
    var subTitle: String
    var films: [Film] = [
        Film(id: .init(), date: .init(), coordinate: nil, image: URL(string: "https://naver.com")!, focalLength: .init(value: 70), iso: .init(iso: 400), shutterSpeed: .init(denominator: 500), aperture: .init(value: 11), memo: ""),
        Film(id: .init(), date: .init(), coordinate: nil, image: URL(string: "https://naver.com")!, focalLength: .init(value: 70), iso: .init(iso: 400), shutterSpeed: .init(denominator: 500), aperture: .init(value: 11), memo: ""),
        Film(id: .init(), date: .init(), coordinate: nil, image: URL(string: "https://naver.com")!, focalLength: .init(value: 70), iso: .init(iso: 400), shutterSpeed: .init(denominator: 500), aperture: .init(value: 11), memo: ""),
        Film(id: .init(), date: .init(), coordinate: nil, image: URL(string: "https://naver.com")!, focalLength: .init(value: 70), iso: .init(iso: 400), shutterSpeed: .init(denominator: 500), aperture: .init(value: 11), memo: ""),
    ]
    var currentIndex: Int = .zero
    
    func onAppear() {}
    
    init(mainTitle: String = "금문교", subTitle: String = "오늘 - 13:54") {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
    }
}
