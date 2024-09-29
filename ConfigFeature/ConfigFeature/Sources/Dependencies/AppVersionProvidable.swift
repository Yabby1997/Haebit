//
//  AppVersionProvidable.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public protocol AppVersionProvidable: Actor {
    var currentVersion: String { get }
    func checkLatestVersion() async throws -> String
}
