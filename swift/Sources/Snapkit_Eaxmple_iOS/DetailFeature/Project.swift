import ProjectDescription

let project = Project(
    name: "DetailFeature",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "DetailFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.detailfeature",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Coordinator")),
                .project(target: "DetailFeatureInterface", path: .relativeToRoot("DetailFeatureInterface")),
                .project(target: "DetailDomain", path: .relativeToRoot("DetailDomain")),
                .project(target: "Design", path: .relativeToRoot("Design")),
                .project(target: "RxSupport", path: .relativeToRoot("RxSupport")),
                .external(name: "ReactorKit"),
                .external(name: "snapkit-image"),
            ]
        )
    ]
)
