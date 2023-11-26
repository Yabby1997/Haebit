import ProjectDescription

let targets: [Target] = [
    Target(
        name: "Haebit",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebit",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: .extendingDefault(with: ["UILaunchStoryboardName": "LaunchScreen"]),
        sources: ["Haebit/Sources/**"],
        resources: ["Haebit/Resources/**"],
        dependencies: [
//            .project(target: "Obscura", path: "../../Feature/Obscura"),
//            .project(target: "LightMeter", path: "../../Feature/LightMeter"),
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
        .remote(url: "https://github.com/Yabby1997/Obscura.git", requirement: .exact("0.1.0")),
        .remote(url: "https://github.com/Yabby1997/LightMeter.git", requirement: .exact("0.1.0")),
    ],
    targets: targets
)
