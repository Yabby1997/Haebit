//
//  ConfigOnboardingViewModel.swift
//  LightMeterFeature
//
//  Created by Seunghun on 10/21/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class ConfigOnboardingViewModel: ObservableObject {
    @Published var offset: CGFloat = 30
    @Published var isHidden: Bool = false
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                offset = offset == 30 ? -30.0 : 30
            }
            .store(in: &cancellable)
    }
}
