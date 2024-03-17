//
//  HaebitFilmListViewModelProtocol.swift
//  Haebit
//
//  Created by Seunghun on 3/17/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

protocol HaebitFilmListViewModelProtocol: ObservableObject {
    var mainTitle: String { get set }
    var subTitle: String { get set }
    var films: [Film] { get set }
    var currentIndex: Int { get set }
    func onAppear()
}
