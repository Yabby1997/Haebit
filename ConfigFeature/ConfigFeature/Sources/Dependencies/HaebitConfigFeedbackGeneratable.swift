//
//  HaebitConfigFeedbackGeneratable.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public protocol HaebitConfigFeedbackGeneratable {
    @MainActor
    func generate(feedback: FeedbackStyle)
}
