import ProjectDescription

let project = Project(
    name: "RxSupport",
    packages: [
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "RxSupport",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.test.rxsupport",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RxSwift"),
            ]
        )
    ]
)
