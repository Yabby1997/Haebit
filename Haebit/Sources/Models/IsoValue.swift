//
//  IsoValue.swift
//  Haebit
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

struct IsoValue: Hashable, Codable {
    let iso: Int
    var value: Float { Float(iso) }
    var title: String { "\(iso)" }
    var description: String { title }
}
