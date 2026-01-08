import ProjectDescription

let project = Project(
    name: "DetailDomain",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "DetailDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.detaildomain",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "CoreDomain", path: .relativeToRoot("CoreDomain")),
            ]
        )
    ]
)
