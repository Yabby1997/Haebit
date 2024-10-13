//
//  SystemInfoProvidable.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

protocol SystemInfoProvidable {
    @MainActor
    var systemVersion: String { get }
    @MainActor
    var modelName: String { get }
}
