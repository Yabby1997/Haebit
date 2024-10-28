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
    @Published var isLowered = true
    @Published var isHidden: Bool = false
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        bind()
    }
    
    private func bind() {
        Timer.publish(every: 1.2, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                isLowered.toggle()
            }
            .store(in: &cancellable)
    }
}
