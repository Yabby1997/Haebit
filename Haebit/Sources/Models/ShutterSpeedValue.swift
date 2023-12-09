//
//  ShutterSpeedValue.swift
//  Haebit
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

struct ShutterSpeedValue: Hashable {
    let denominator: Int
    var value: Float { 1 / Float(denominator) }
    var title: String { "¹⁄" + (String(Int(denominator)).compactMap { $0.subscript }).reduce("") { $0 + String($1) } + "s" }
    var description: String { "¹⁄ \(Int(denominator))s"}
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
