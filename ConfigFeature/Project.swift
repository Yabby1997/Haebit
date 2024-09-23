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
    .external(name: "HaebitCommonModels"),
]

let devDependencies: [TargetDependency] = [
    .project(target: "HaebitCommonModels", path: "../../../Modules/HaebitCommonModels"),
]

let targets: [Target] = [
    Target(
        name: "ConfigFeature",
        platform: .iOS,
        product: .framework,
        bundleId: "com.seunghun.haebit.configFeature",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        sources: ["ConfigFeature/Sources/**"],
        resources: ["ConfigFeature/Resources/**"],
        dependencies: devDependencies,
        settings: .settings(base: ["SWIFT_STRICT_CONCURRENCY": "complete"])
    ),
    Target(
        name: "ConfigFeatureDemo",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.configFeature.demo",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: plist,
        sources: ["ConfigFeatureDemo/Sources/**"],
        resources: ["ConfigFeatureDemo/Resources/**"],
        dependencies: [
            .target(name: "ConfigFeature")
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
    name: "ConfigFeature",
    organizationName: "seunghun",
    targets: targets
)
