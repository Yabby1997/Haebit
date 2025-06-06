//
//  LocalizedStringResource+Extensions.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

extension LocalizedStringResource {
    static let headerReviewRequestTitle: Self = .init("headerReviewRequestTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let headerReviewRequestDescription: Self = .init("headerReviewRequestDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let headerControlSectionTitle: Self = .init("headerControlSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let headerControlSectionDescription: Self = .init("headerControlSectionDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let headerFeedbackSectionTitle: Self = .init("headerFeedbackSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let headerFeedbackSectionDescription: Self = .init("headerFeedbackSectionDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let headerSoundSectionTitle: Self = .init("headerSoundSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let headerSoundSectionDescription: Self = .init("headerSoundSectionDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let headerAppearanceSectionTitle: Self = .init("headerAppearanceSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let headerAppearanceSectionDescription: Self = .init("headerAppearanceSectionDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let featureSectionRotationTitle: Self = .init("featureSectionRotationTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let featureSectionTitle: Self = .init("featureSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionApertureTitle: Self = .init("controlSectionApertureTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionShutterSpeedTitle: Self = .init("controlSectionShutterSpeedTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionIsoTitle: Self = .init("controlSectionIsoTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionFocalLengthTitle: Self = .init("controlSectionFocalLengthTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionTitle: Self = .init("controlSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionDescription: Self = .init("controlSectionDescription", bundle: .atURL(Bundle.module.bundleURL))
    static func controlSectionItems(count: Int) -> Self { return .init("controlSectionItems\(count)", bundle: .atURL(Bundle.module.bundleURL)) }
    static let controlSectionCommonNewEntryTitle: Self = .init("controlSectionCommonNewEntryTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionCommonEntriesDescription: Self = .init("controlSectionCommonEntriesDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionApertureEntriesDescription: Self = .init("controlSectionApertureEntriesDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionFocalLengthEntriesDescription: Self = .init("controlSectionFocalLengthEntriesDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionFocalLengthEntriesDescription2: Self = .init("controlSectionFocalLengthEntriesDescription2", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionIsoEntriesDescription: Self = .init("controlSectionIsoEntriesDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let controlSectionShutterSpeedEntriesDescription: Self = .init("controlSectionShutterSpeedEntriesDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionApertureRingTitle: Self = .init("feedbackSectionApertureRingTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionShutterSpeedDialTitle: Self = .init("feedbackSectionShutterSpeedDialTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionIsoDialTitle: Self = .init("feedbackSectionIsoDialTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionExposureCompensationDialTitle: Self = .init("feedbackSectionExposureCompensationDialTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionFocalLengthRingTitle: Self = .init("feedbackSectionFocalLengthRingTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let feedbackSectionTitle: Self = .init("feedbackSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionFeedbackAndInquiryTitle: Self = .init("othersSectionFeedbackAndInquiryTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionReviewOnAppstoreTitle: Self = .init("othersSectionReviewOnAppstoreTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionVersionTitle: Self = .init("othersSectionVersionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionLatestDescription: Self = .init("othersSectionLatestDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionUpdateAvailableDescription: Self = .init("othersSectionUpdateAvailableDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let othersSectionTitle: Self = .init("othersSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let soundSectionShutterSoundOptionTitle: Self = .init("soundSectionShutterSoundOptionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let soundSectionTitle: Self = .init("soundSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionPreviewTitle: Self = .init("appearanceSectionPreviewTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionPreviewDescription: Self = .init("appearanceSectionPreviewDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionPreviewDescription2: Self = .init("appearanceSectionPreviewDescription2", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionPerforationTitle: Self = .init("appearanceSectionPerforationTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionPerforationDescription: Self = .init("appearanceSectionPerforationDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionFilmCanisterTitle: Self = .init("appearanceSectionFilmCanisterTitle", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionFilmCanisterDescription: Self = .init("appearanceSectionFilmCanisterDescription", bundle: .atURL(Bundle.module.bundleURL))
    static let appearanceSectionTitle: Self = .init("appearanceSectionTitle", bundle: .atURL(Bundle.module.bundleURL))
}
