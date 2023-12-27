//
//  DefaultReviewRequestValidator.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Combine
import Foundation

final class DefaultReviewRequestValidator: ReviewRequestValidatable {
    // MARK: - Public Properties
    
    var shouldRequestReview: AnyPublisher<Bool, Never> { $_shouldRequestReview.eraseToAnyPublisher() }
    
    // MARK: - Private properties
    
    @Published private var _shouldRequestReview = false
    
    @UserDefault(key: "DefaultReviewRequestValidator.flag", defaultValue: 0)
    private var flag: Int
    
    // MARK: - Initializers
    
    init() {
        validate()
    }
    
    // MARK: - Private methods
    
    private func validate() {
        flag = (flag + 1) % 5
        guard flag == 0 else { return }
        _shouldRequestReview = true
    }
}
