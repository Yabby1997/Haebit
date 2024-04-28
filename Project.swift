import ProjectDescription

let majorVersion: Int = 1
let minorVersion: Int = 3
let patchVersion: Int = 0
let versionString: Plist.Value = "\(majorVersion).\(minorVersion).\(patchVersion)"

let plist: InfoPlist = .extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIImageName": "LaunchScreenIcon",
            "UIColorName": "LaunchScreenBackgroundColor",
        ],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "NSCameraUsageDescription": "Camera permission is needed for ObscuraDemo",
        "NSLocationWhenInUseUsageDescription": true,
        "ITSAppUsesNonExemptEncryption": false,
        "CFBundleShortVersionString": versionString,
    ]
)

let remotePackages: [Package] = [
    .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.7.1")),
]

let dependencies: [TargetDependency] = [
    .package(product: "SnapKit", type: .runtime),
    .project(target: "HaebitUI", path: "../../Feature/HaebitUI"),
    .project(target: "Obscura", path: "../../Feature/Obscura"),
    .project(target: "LightMeter", path: "../../Feature/LightMeter"),
    .project(target: "Portolan", path: "../../Feature/Portolan"),
    .project(target: "HaebitLogger", path: "../../Feature/HaebitLogger"),
    .project(target: "HaebitUtil", path: "../../Feature/HaebitUtil"),
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
        dependencies: dependencies,
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
        dependencies: dependencies,
        settings: settings
    )
]

let project = Project(
    name: "Haebit",
    organizationName: "seunghun",
    packages: remotePackages,
    targets: targets
)
