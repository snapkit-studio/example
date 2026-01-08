import ProjectDescription

let project = Project(
    name: "Data",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.data",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "CoreDomain", path: .relativeToRoot("CoreDomain")),
                .project(target: "HomeDomain", path: .relativeToRoot("HomeDomain")),
                .project(target: "DetailDomain", path: .relativeToRoot("DetailDomain")),
                .external(name: "RxSwift"),
                .external(name: "Alamofire")
            ]
        ),
        .target(
            name: "DataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.data.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Data")
            ]
        )
    ]
)
