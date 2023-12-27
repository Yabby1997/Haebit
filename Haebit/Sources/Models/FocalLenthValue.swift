//
//  FocalLenthValue.swift
//  Haebit
//
//  Created by Seunghun on 12/22/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

struct FocalLengthValue: Hashable, Codable {
    let value: Int
    var title: String { "\(value)mm" }
}
