//
//  GPSAccessValidatable.swift
//  HaebitDev
//
//  Created by Seunghun on 3/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation

public protocol GPSAccessValidatable: AnyObject {
    var isAccessAuthorized: Bool { get set }
    var shouldAskGPSAccessPublisher: AnyPublisher<Bool, Never> { get }
    func requestDoNotAsk()
}
