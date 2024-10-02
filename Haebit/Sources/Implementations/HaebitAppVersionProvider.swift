//
//  HaebitAppVersionProvider.swift
//  HaebitDev
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import Foundation

final actor HaebitAppVersionProvider: AppVersionProvidable {
    var currentVersion: String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return buildNumber
    }
    
    func checkLatestVersion() async throws -> String {
        guard let url = URL(string: "https://itunes.apple.com")?
            .appending(path: "lookup")
            .appending(queryItems: [.init(name: "id", value: "6474086258")]) else {
            return "???"
        }
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let lookUpResults = try? JSONDecoder().decode(ItunesLookUpResults.self, from: data) else { return "???" }
        return lookUpResults.results.first?.version ?? "???"
    }
}

fileprivate struct ItunesLookUpResults: Decodable {
    let results: [ItunesLookUpResult]
}

fileprivate struct ItunesLookUpResult: Decodable {
    let version: String
}
