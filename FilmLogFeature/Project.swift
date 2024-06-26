import ProjectDescription

let plist: InfoPlist = .extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIImageName": "LaunchScreenIcon",
            "UIColorName": "LaunchScreenBackgroundColor",
        ],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UIUserInterfaceStyle": "Dark",
        "NSLocationWhenInUseUsageDescription": true,
        "ITSAppUsesNonExemptEncryption": false,
    ]
)

let releasedDependencies: [TargetDependency] = [
    .external(name: "SnapKit"),
    .external(name: "HaebitCommonModels"),
    .external(name: "HaebitLogger"),
    .external(name: "HaebitUtil"),
    .external(name: "Portolan"),
]

let devDependencies: [TargetDependency] = [
    .external(name: "SnapKit"),
    .project(target: "HaebitCommonModels", path: "../../../Modules/HaebitCommonModels"),
    .project(target: "HaebitLogger", path: "../../../Modules/HaebitLogger"),
    .project(target: "HaebitUtil", path: "../../../Modules/HaebitUtil"),
    .project(target: "Portolan", path: "../../../Modules/Portolan"),
]

let targets: [Target] = [
    Target(
        name: "FilmLogFeature",
        platform: .iOS,
        product: .framework,
        bundleId: "com.seunghun.haebit.filmlogfeature",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        sources: ["FilmLogFeature/Sources/**"],
        resources: ["FilmLogFeature/Resources/**"],
        dependencies: devDependencies,
        settings: .settings(base: ["SWIFT_STRICT_CONCURRENCY": "complete"])
    ),
    Target(
        name: "FilmLogFeatureDemo",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.filmlogfeature.demo",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: plist,
        sources: ["FilmLogFeatureDemo/Sources/**"],
        resources: ["FilmLogFeatureDemo/Resources/**"],
        dependencies: [
            .target(name: "FilmLogFeature")
        ],
        settings: .settings(
            base: [
                "DEVELOPMENT_TEAM": "5HZQ3M82FA",
                "SWIFT_STRICT_CONCURRENCY": "complete"
            ],
            configurations: [],
            defaultSettings: .recommended
        )
    )
]

let project = Project(
    name: "FilmLogFeature",
    organizationName: "seunghun",
    targets: targets
)
