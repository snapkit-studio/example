import ProjectDescription

let project = Project(
    name: "CoreDomain",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "CoreDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.coredomain",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RxSwift"),
            ]
        )
    ]
)

