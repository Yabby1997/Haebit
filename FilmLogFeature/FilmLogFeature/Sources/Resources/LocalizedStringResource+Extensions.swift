//
//  LocalizedStringResource+Extensions.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

extension LocalizedStringResource {
    static let apertureInputViewTitle: Self = .init("apertureInputViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let focalLengthInputViewTitle: Self = .init("focalLengthInputViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let isoInputViewTitle: Self = .init("isoInputViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let shutterSpeedInputViewTitle: Self = .init("shutterSpeedInputViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let mapInfoSearchViewNoResults: Self = .init("mapInfoSearchViewNoResults", bundle: .atURL(Bundle.module.bundleURL))
    static let mapInfoSearchViewQueryPlaceholder: Self = .init("mapInfoSearchViewQueryPlaceholder", bundle: .atURL(Bundle.module.bundleURL))
    static let mapInfoViewRemoveCoordinate: Self = .init("mapInfoViewRemoveCoordinate", bundle: .atURL(Bundle.module.bundleURL))
    static let mapInfoViewSearchCoordinate: Self = .init("mapInfoViewSearchCoordinate", bundle: .atURL(Bundle.module.bundleURL))
    static let dateInfoViewTitle: Self = .init("dateInfoViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewTitle: Self = .init("filmInfoViewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewDeleteConfirmationTitle: Self = .init("filmInfoViewDeleteConfirmationTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewDeleteConfirmationDelete: Self = .init("filmInfoViewDeleteConfirmationDelete", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewUpdateConfirmationTitle: Self = .init("filmInfoViewUpdateConfirmationTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewUpdateConfirmationAbandon: Self = .init("filmInfoViewUpdateConfirmationAbandon", bundle: .atURL(Bundle.module.bundleURL))
    static let filmInfoViewUpdateConfirmationUpdate: Self = .init("filmInfoViewUpdateConfirmationUpdate", bundle: .atURL(Bundle.module.bundleURL))
    static let memoViewPlaceholder: Self = .init("memoViewPlaceholder", bundle: .atURL(Bundle.module.bundleURL))
}
