// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FlashcardApp",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .executable(name: "FlashcardApp", targets: ["FlashcardApp"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlashcardApp",
            dependencies: [],
            path: "FlashcardApp"
        ),
        .testTarget(
            name: "FlashcardAppTests",
            dependencies: ["FlashcardApp"],
            path: "FlashcardAppTests"
        )
    ]
)