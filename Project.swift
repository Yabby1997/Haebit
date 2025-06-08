import ProjectDescription

let majorVersion: Int = 1
let minorVersion: Int = 5
let patchVersion: Int = 0
let versionString: Plist.Value = "\(majorVersion).\(minorVersion).\(patchVersion)"

let plist: InfoPlist = .extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIImageName": "LaunchScreenIcon",
            "UIColorName": "LaunchScreenBackgroundColor",
        ],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UIUserInterfaceStyle": "Dark",
        "NSCameraUsageDescription": "Camera permission is needed for ObscuraDemo",
        "NSLocationWhenInUseUsageDescription": true,
        "ITSAppUsesNonExemptEncryption": false,
        "CFBundleShortVersionString": versionString,
    ]
)

let releasedDependencies: [TargetDependency] = [
    .project(target: "LightMeterFeature", path: "LightMeterFeature"),
    .project(target: "FilmLogFeature", path: "FilmLogFeature"),
    .project(target: "ConfigFeature", path: "ConfigFeature"),
    .external(name: "Obscura"),
]

let devDependencies: [TargetDependency] = [
    .project(target: "LightMeterFeature", path: "LightMeterFeature"),
    .project(target: "FilmLogFeature", path: "FilmLogFeature"),
    .project(target: "ConfigFeature", path: "ConfigFeature"),
    .project(target: "Obscura", path: "../../Modules/Obscura"),
]

let settings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEAM": "5HZQ3M82FA",
        "SWIFT_STRICT_CONCURRENCY": "complete"
    ],
    configurations: [],
    defaultSettings: .recommended
)

let targets: [Target] = [
    Target(
        name: "HaebitDev",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.dev",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: plist,
        sources: ["Haebit/Sources/**"],
        resources: [
            "Haebit/Resources/Common/**",
            "Haebit/Resources/Dev/**"
        ],
        dependencies: devDependencies,
        settings: settings
    ),
    Target(
        name: "Haebit",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: plist,
        sources: ["Haebit/Sources/**"],
        resources: [
            "Haebit/Resources/Common/**",
            "Haebit/Resources/Real/**"
        ],
        dependencies: devDependencies,
        settings: settings
    )
]

let project = Project(
    name: "Haebit",
    organizationName: "seunghun",
    targets: targets
)
