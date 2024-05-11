//
//  Dependencies.swift
//  FilmLogFeatureManifests
//
//  Created by Seunghun on 5/11/24.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [.remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.7.1"))]
    ),
    platforms: [.iOS]
)
