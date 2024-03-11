import ProjectDescription

let majorVersion: Int = 1
let minorVersion: Int = 2
let patchVersion: Int = 0
let versionString: Plist.Value = "\(majorVersion).\(minorVersion).\(patchVersion)"

let targets: [Target] = [
    Target(
        name: "HaebitDev",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.dev",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(
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
        ),
        sources: ["Haebit/Sources/**"],
        resources: [
            "Haebit/Resources/Common/**",
            "Haebit/Resources/Dev/**"
        ],
        dependencies: [
            .package(product: "SnapKit", type: .runtime),
//            .project(target: "HaebitUI", path: "../../Feature/HaebitUI"),
//            .project(target: "Obscura", path: "../../Feature/Obscura"),
//            .project(target: "LightMeter", path: "../../Feature/LightMeter"),
//            .project(target: "Portolan", path: "../../Feature/Portolan"),
//            .project(target: "HaebitLogger", path: "../../Feature/HaebitLogger"),
//            .project(target: "HaebitUtil", path: "../../Feature/HaebitUtil"),
            .package(product: "HaebitUI", type: .runtime),
            .package(product: "Obscura", type: .runtime),
            .package(product: "LightMeter", type: .runtime),
            .package(product: "Portolan", type: .runtime),
            .package(product: "HaebitLogger", type: .runtime),
            .package(product: "HaebitUtil", type: .runtime),
        ],
        settings: .settings(
            base: ["DEVELOPMENT_TEAM": "5HZQ3M82FA"],
            configurations: [],
            defaultSettings: .recommended
        )
    ),
    Target(
        name: "HaebitRC",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit.rc",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(
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
        ),
        sources: ["Haebit/Sources/**"],
        resources: ["Haebit/Resources/Common/**"],
        dependencies: [
            .package(product: "SnapKit", type: .runtime),
            .package(product: "HaebitUI", type: .runtime),
            .package(product: "Obscura", type: .runtime),
            .package(product: "LightMeter", type: .runtime),
            .package(product: "Portolan", type: .runtime),
            .package(product: "HaebitLogger", type: .runtime),
            .package(product: "HaebitUtil", type: .runtime),
        ],
        settings: .settings(
            base: ["DEVELOPMENT_TEAM": "5HZQ3M82FA"],
            configurations: [],
            defaultSettings: .recommended
        )
    ),
    Target(
        name: "Haebit",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit",
        deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
        infoPlist: .extendingDefault(
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
        ),
        sources: ["Haebit/Sources/**"],
        resources: ["Haebit/Resources/Common/**"],
        dependencies: [
            .package(product: "SnapKit", type: .runtime),
            .package(product: "HaebitUI", type: .runtime),
            .package(product: "Obscura", type: .runtime),
            .package(product: "LightMeter", type: .runtime),
            .package(product: "Portolan", type: .runtime),
            .package(product: "HaebitLogger", type: .runtime),
            .package(product: "HaebitUtil", type: .runtime),
        ],
        settings: .settings(
            base: ["DEVELOPMENT_TEAM": "5HZQ3M82FA"],
            configurations: [],
            defaultSettings: .recommended
        )
    )
]

let project = Project(
    name: "Haebit",
    organizationName: "seunghun",
    packages: [
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.7.1")),
        .remote(url: "https://github.com/Yabby1997/HaebitUI.git", requirement: .exact("0.3.0")),
        .remote(url: "https://github.com/Yabby1997/Obscura.git", requirement: .exact("0.5.0")),
        .remote(url: "https://github.com/Yabby1997/LightMeter.git", requirement: .exact("0.1.0")),
        .remote(url: "https://github.com/Yabby1997/Portolan.git", requirement: .exact("0.1.0")),
        .remote(url: "https://github.com/Yabby1997/HaebitLogger.git", requirement: .exact("0.1.1")),
        .remote(url: "https://github.com/Yabby1997/HaebitUtil.git", requirement: .exact("0.1.0")),
    ],
    targets: targets
)
