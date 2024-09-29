//
//  MockAppVersionProvider.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import Foundation

final actor MockAppVersionProvider: AppVersionProvidable {
    var currentVersion: String {
        "1.4.0"
    }
    
    func checkLatestVersion() throws -> String {
        "1.4.1"
    }
}
