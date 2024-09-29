//
//  AppStoreOpener.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public protocol AppStoreOpener {
    @MainActor
    func openWriteReview()
    @MainActor
    func openAppPage()
}
