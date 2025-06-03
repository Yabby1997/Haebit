//
//  LocalizedStringResource+Exntensions.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

extension LocalizedStringResource {
    static let cameraAccessAlertTitle: Self = .init("cameraAccessAlertTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let cameraAccessAlertMessage: Self = .init("cameraAccessAlertMessage", bundle: .atURL(Bundle.module.bundleURL))
    static let gpsAccessAlertTitle: Self = .init("gpsAccessAlertTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let gpsAccessAlertMessage: Self = .init("gpsAccessAlertMessage", bundle: .atURL(Bundle.module.bundleURL))
    static let gpsAccessDoNotAskAgainButton: Self = .init("gpsAccessDoNotAskAgainButton", bundle: .atURL(Bundle.module.bundleURL))
    static let alertOpenSettingsButton: Self = .init("alertOpenSettingsButton", bundle: .atURL(Bundle.module.bundleURL))
    static let controlViewUnlockButton: Self = .init("controlViewUnlockButton", bundle: .atURL(Bundle.module.bundleURL))
    static let configOnboardingViewTitle: Self = .init("configOnboardingViewTitle", bundle: .atURL(Bundle.module.bundleURL))
}
