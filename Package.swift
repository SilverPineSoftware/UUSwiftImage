// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UUSwiftImage",
	platforms: [
		.iOS(.v15),
		.macOS(.v11)
	],

	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "UUSwiftImage",
			targets: ["UUSwiftImage"]),
	],

	dependencies: [
		// Here we define our package's external dependencies
		// and from where they can be fetched:
		.package(
			url: "https://github.com/SilverPineSoftware/UUSwiftCore.git",
			branch: "develop"
		)
	],

	targets: [
		.target(
			name: "UUSwiftImage",
			dependencies: ["UUSwiftCore"],
			path: "UUSwiftImage",
			exclude: ["Info.plist"])
	],
    swiftLanguageModes: [
		.v4_2,
		.v5,
        .v6
	]
)
