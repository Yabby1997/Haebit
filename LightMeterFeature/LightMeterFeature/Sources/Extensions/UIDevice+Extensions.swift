//
//  UIDevice+Extensions.swift
//  Haebit
//
//  Created by Seunghun on 12/23/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import HaebitCommonModels
import UIKit

public extension UIDevice {
    nonisolated static var focalLength: CGFloat {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPhone10,1", "iPhone10,4", "iPhone10,2", "iPhone10,5", "iPhone10,3",
            "iPhone10,6", "iPhone8,4", "iPhone12,8", "iPhone14,6":
            return 28
        case "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8", "iPhone12,1",
            "iPhone12,3", "iPhone12,5", "iPhone13,1", "iPhone13,2", "iPhone13,3",
            "iPhone13,4", "iPhone14,4", "iPhone14,5", "iPhone14,2", "iPhone14,3",
            "iPhone14,7", "iPhone14,8", "iPhone15,4", "iPhone15,5":
            return 26
        case "iPhone15,2", "iPhone15,3", "iPhone16,1", "iPhone16,2":
            return 24
        default:
            return 28
        }
    }
}

extension FocalLengthValue {
    var zoomFactor: CGFloat { CGFloat(value) / UIDevice.focalLength }
}
