//
//  ReviewRequestValidatable.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Combine
import Foundation

public protocol ReviewRequestValidatable: AnyObject {
    var shouldRequestReviewPublisher: AnyPublisher<Bool, Never> { get }
}
