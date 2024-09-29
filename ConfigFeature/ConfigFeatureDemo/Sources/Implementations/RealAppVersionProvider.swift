//
//  RealAppVersionProvider.swift
//  ConfigFeatureDemo
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import Foundation

final actor RealAppVersionProvider: AppVersionProvidable {
    private let appID: String
    
    var currentVersion: String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return buildNumber
    }
    
    init(appID: String) {
        self.appID = appID
    }
    
    func checkLatestVersion() async throws -> String {
        guard let url = URL(string: "https://itunes.apple.com")?
            .appending(path: "lookup")
            .appending(queryItems: [.init(name: "id", value: appID)]) else {
            return "???"
        }
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let lookUpResults = try? JSONDecoder().decode(ItunesLookUpResults.self, from: data) else { return "???" }
        return lookUpResults.results.first?.version ?? "???"
    }
}

struct ItunesLookUpResults: Decodable {
    let results: [ItunesLookUpResult]
}

struct ItunesLookUpResult: Decodable {
    let version: String
}
