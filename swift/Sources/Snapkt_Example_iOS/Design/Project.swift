import ProjectDescription

let project = Project(
    name: "Design",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "Design",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.design",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/Assets.xcassets"],
            dependencies: [
                .external(name: "SnapKit")
            ]
        )
    ]
)

