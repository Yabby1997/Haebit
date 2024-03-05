import ProjectDescription

let majorVersion: Int = 1
let minorVersion: Int = 1
let patchVersion: Int = 2
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
                "NSPhotoLibraryAddUsageDescription": "Need photo library access to save result",
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
            .project(target: "HaebitUI", path: "../../Feature/HaebitUI"),
            .project(target: "Obscura", path: "../../Feature/Obscura"),
            .project(target: "LightMeter", path: "../../Feature/LightMeter"),
            .project(target: "Portolan", path: "../../Feature/Portolan"),
            .project(target: "HaebitLogger", path: "../../Feature/HaebitLogger"),
            .package(product: "SnapKit", type: .runtime),
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
                "NSPhotoLibraryAddUsageDescription": "Need photo library access to save result",
                "NSLocationWhenInUseUsageDescription": true,
                "ITSAppUsesNonExemptEncryption": false,
                "CFBundleShortVersionString": versionString,
            ]
        ),
        sources: ["Haebit/Sources/**"],
        resources: [
            "Haebit/Resources/Common/**",
            "Haebit/Resources/RC/**"
        ],
        dependencies: [
            .package(product: "HaebitUI", type: .runtime),
            .package(product: "Obscura", type: .runtime),
            .package(product: "LightMeter", type: .runtime),
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
                "NSPhotoLibraryAddUsageDescription": "Need photo library access to save result",
                "NSLocationWhenInUseUsageDescription": true,
                "ITSAppUsesNonExemptEncryption": false,
                "CFBundleShortVersionString": versionString,
            ]
        ),
        sources: ["Haebit/Sources/**"],
        resources: [
            "Haebit/Resources/Common/**",
            "Haebit/Resources/Real/**"
        ],
        dependencies: [
            .package(product: "HaebitUI", type: .runtime),
            .package(product: "Obscura", type: .runtime),
            .package(product: "LightMeter", type: .runtime),
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
        .remote(url: "https://github.com/Yabby1997/HaebitUI.git", requirement: .exact("0.2.1")),
        .remote(url: "https://github.com/Yabby1997/Obscura.git", requirement: .exact("0.4.0")),
        .remote(url: "https://github.com/Yabby1997/LightMeter.git", requirement: .exact("0.1.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.7.1")),
    ],
    targets: targets
)
