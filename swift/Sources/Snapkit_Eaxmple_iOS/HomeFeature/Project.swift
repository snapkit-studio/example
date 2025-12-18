import ProjectDescription

let project = Project(
    name: "HomeFeature",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "HomeFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.homefeature",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Coordinator", path: .relativeToRoot("Coordinator")),
                .project(target: "DetailFeatureInterface", path: .relativeToRoot("DetailFeatureInterface")),
                .project(target: "HomeDomain", path: .relativeToRoot("HomeDomain")),
                .project(target: "Design", path: .relativeToRoot("Design")),
                .project(target: "RxSupport", path: .relativeToRoot("RxSupport")),
                .external(name: "ReactorKit"),
                .external(name: "snapkit-image")
            ]
        ),
        .target(
            name: "HomeFeatureTests",
            destinations: .iOS,
            product: .unitTests, // 여기서 Swift Testing을 위한 Unit Tests 생성
            bundleId: "com.data.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "HomeFeature")
            ]
        )
    ]
)
