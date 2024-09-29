//
//  HeaderType.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

enum HeaderType: CaseIterable {
    case tipJar
    case reviewRequest
    case filmCanister
    
    var next: HeaderType {
        HeaderType.allCases.drop { $0 != self }.dropFirst().first ?? .tipJar
    }
}
