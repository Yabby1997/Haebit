//
//  HaebitAppStoreOpener.swift
//  HaebitDev
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import Foundation
import UIKit

final class HaebitAppStoreOpener: AppStoreOpener {
    private let baseURL: URL?
    
    init(locale: String) {
        self.baseURL = URL(string: "itms-apps://itunes.apple.com")?
            .appending(path: locale)
            .appending(path: "app")
            .appending(path: "id6474086258")
        
    }
    
    func openWriteReview() {
        guard let url = baseURL?.appending(
            queryItems: [
                .init(name: "action", value: "write-review"),
                .init(name: "mt", value: "8")
            ]
        ) else { return }
        open(url: url)
    }
    
    func openAppPage() {
        guard let baseURL else { return }
        open(url: baseURL)
    }

    @MainActor
    private func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
