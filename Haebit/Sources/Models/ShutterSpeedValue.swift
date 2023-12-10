//
//  ShutterSpeedValue.swift
//  Haebit
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

struct ShutterSpeedValue: Hashable {
    let denominator: Float
    var value: Float { 1 / Float(denominator) }
    var title: String { isLessThanOneSecond ? "¹⁄" + Int(denominator).subscriptString + "s" : "\(Int(1 / denominator))s" }
    var description: String { isLessThanOneSecond ? "¹⁄ \(Int(denominator))s" : "\(Int(1 / denominator))s" }
    private var isLessThanOneSecond: Bool { denominator > 1 }
}

extension Int {
    fileprivate var subscriptString: String {
        String(self).compactMap { $0.subscript }.reduce("") { $0 + String($1) }
    }
}

extension String.Element {
    fileprivate var `subscript`: Self? {
        switch self {
        case "0": return "₀"
        case "1": return "₁"
        case "2": return "₂"
        case "3": return "₃"
        case "4": return "₄"
        case "5": return "₅"
        case "6": return "₆"
        case "7": return "₇"
        case "8": return "₈"
        case "9": return "₉"
        default: return nil
        }
    }
}
