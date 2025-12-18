import ProjectDescription

let project = Project(
    name: "HomeDomain",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "HomeDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.homedomain",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "CoreDomain", path: .relativeToRoot("CoreDomain")),
            ]
        )
    ]
) 

