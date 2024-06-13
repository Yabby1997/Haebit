import ProjectDescription

let plist: InfoPlist = .extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIImageName": "LaunchScreenIcon",
            "UIColorName": "LaunchScreenBackgroundColor",
        ],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UIUserInterfaceStyle": "Dark",
        "NSCameraUsageDescription": "Camera permission is needed for LightMeterFeatureDemo",
        "NSLocationWhenInUseUsageDescription": true,
        "ITSAppUsesNonExemptEncryption": false,
    ]
)

let releasedDependencies: [TargetDependency] = [
    .external(name: "HaebitCommonModels"),
    .external(name: "HaebitUI"),
    .external(name: "LightMeter"),
    .external(name: "Obscura"),
    .external(name: "Portolan"),
]

let devDependencies: [TargetDependency] = [
    .project(target: "HaebitCommonModels", path: "../../../Modules/HaebitCommonModels"),
    .project(target: "HaebitUI", path: "../../../Modules/HaebitUI"),
    .project(target: "LightMeter", path: "../../../Modules/LightMeter"),
    .project(target: "Obscura", path: "../../../Modules/Obscura"),
    .project(target: "Portolan", path: "../../../Modules/Portolan"),
]

let targets: [Target] = [
    Target(
        name: "LightMeterFeature",
        platform: .iOS,
        product: .framework,
        bundleId: "com.seunghun.haebit.lightmeterfeature",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        sources: ["LightMeterFeature/Sources/**"],
        resources: ["LightMeterFeature/Resources/**"],
        dependencies: devDependencies,
        settings: .settings(base: ["SWIFT_STRICT_CONCURRENCY": "complete"])
    ),
    Target(
        name: "LightMeterFeatureDemo",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.lightmeterfeature.demo",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: plist,
        sources: ["LightMeterFeatureDemo/Sources/**"],
        resources: ["LightMeterFeatureDemo/Resources/**"],
        dependencies: [
            .target(name: "LightMeterFeature")
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
    name: "LightMeterFeature",
    organizationName: "seunghun",
    targets: targets
)
