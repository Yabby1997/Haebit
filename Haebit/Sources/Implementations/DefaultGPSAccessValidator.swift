//
//  DefaultGPSAccessValidator.swift
//  HaebitDev
//
//  Created by Seunghun on 3/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import LightMeterFeature

final class DefaultGPSAccessValidator: GPSAccessValidatable {
    @UserDefault(key: "DefaultGPSAccessValidator.userRequestedDoNotAsk", defaultValue: false)
    private var userRequestedDoNotAsk: Bool
    @UserDefault(key: "DefaultGPSAccessValidator.isAccessAuthorized", defaultValue: false)
    var isAccessAuthorized: Bool {
        didSet { validate() }
    }
    
    init() {
        validate()
    }
    
    @Published private var shouldAskGPSAccess: Bool = false
    var shouldAskGPSAccessPublisher: AnyPublisher<Bool, Never> {
        $shouldAskGPSAccess
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func requestDoNotAsk() {
        userRequestedDoNotAsk = true
        validate()
    }
    
    private func validate() {
        shouldAskGPSAccess = !isAccessAuthorized && !userRequestedDoNotAsk
    }
}
