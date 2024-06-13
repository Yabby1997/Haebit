//
//  Dependencies.swift
//  FilmLogFeatureManifests
//
//  Created by Seunghun on 5/11/24.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.7.1")),
            .remote(url: "https://github.com/Yabby1997/HaebitCommonModels", requirement: .exact("0.1.0")),
            .remote(url: "https://github.com/Yabby1997/HaebitLogger", requirement: .exact("0.3.1")),
            .remote(url: "https://github.com/Yabby1997/HaebitUtil", requirement: .exact("0.1.1")),
            .remote(url: "https://github.com/Yabby1997/Portolan", requirement: .exact("0.2.0")),
        ]
    ),
    platforms: [.iOS]
)
