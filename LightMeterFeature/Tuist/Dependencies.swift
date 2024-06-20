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
            .remote(url: "https://github.com/Yabby1997/HaebitCommonModels", requirement: .exact("0.1.1")),
            .remote(url: "https://github.com/Yabby1997/HaebitUI", requirement: .exact("0.3.1")),
            .remote(url: "https://github.com/Yabby1997/LightMeter", requirement: .exact("0.2.0")),
            .remote(url: "https://github.com/Yabby1997/Obscura", requirement: .exact("0.6.0")),
            .remote(url: "https://github.com/Yabby1997/Portolan", requirement: .exact("0.2.1")),
        ]
    ),
    platforms: [.iOS]
)
