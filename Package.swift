// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CustomizableCalendar",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "CustomizableCalendar", targets: ["CustomizableCalendar"]),
    ],
    targets: [
        .target(
            name: "CustomizableCalendar",
            path: "Sources/CustomizableCalendar"
        ),
        .testTarget(
            name: "CustomizableCalendarTests",
            dependencies: ["CustomizableCalendar"],
            path: "CustomizableCalendarTests"
        ),
    ]
)
