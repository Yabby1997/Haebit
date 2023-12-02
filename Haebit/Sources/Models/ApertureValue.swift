//
//  ApertureValue.swift
//  Haebit
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

struct ApertureValue: Hashable {
    let value: Float
    var title: String { String(format: "ƒ%g", value) }
}
