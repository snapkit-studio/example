import ProjectDescription

let project = Project(
    name: "Snapkit_Eaxmple_iOS",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [
        .target(
            name: "Snapkit_Eaxmple_iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.ios",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ]
            ]),
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "place1.json",
                "place2.json",
                "place3.json",
                "place4.json",
                "banner.json",
                "curations.json",
                "categories.json",
                "detail.json",
                "tags.json",
                "place1_original.json",
                "place2_original.json",
                "place3_original.json",
                "place4_original.json",
                "banner_original.json",
                "curations_original.json",
                "categories_original.json",
                "detail_original.json",
                "tags_original.json",
            ],
            dependencies: [
                .project(target: "Data", path: .relativeToRoot("Data")),
                .project(target: "HomeDomain", path: .relativeToRoot("HomeDomain")),
                .project(target: "HomeFeature", path: .relativeToRoot("HomeFeature")),
                .project(target: "DetailDomain", path: .relativeToRoot("DetailDomain")),
                .project(target: "DetailFeature", path: .relativeToRoot("DetailFeature")),
                .project(target: "Coordinator", path: .relativeToRoot("Coordinator")),
                .project(target: "DetailFeatureInterface", path: .relativeToRoot("DetailFeatureInterface"))
            ]
        )
    ]
)

