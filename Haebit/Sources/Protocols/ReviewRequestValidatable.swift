//
//  ReviewRequestValidatable.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Combine
import Foundation

protocol ReviewRequestValidatable: AnyObject {
    var shouldRequestReview: AnyPublisher<Bool, Never> { get }
}
