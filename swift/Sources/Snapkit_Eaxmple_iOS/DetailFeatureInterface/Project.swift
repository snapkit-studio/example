import ProjectDescription

let project = Project(
    name: "DetailFeatureInterface",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "DetailFeatureInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.detailfeatureinterface",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Coordinator"))
            ]
        )
    ]
)

