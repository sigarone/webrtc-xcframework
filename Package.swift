// swift-tools-version:5.9
// (Xcode15.0+)

import PackageDescription

// AES-256 fork (sigarone/webrtc-xcframework, branch aes256-livekit, tag
// 144.7559.03-aes256-livekit) — points the binaryTarget at a drop-in
// LiveKitWebRTC.xcframework built by sigarone/webrtc-aes256-build's
// build-livekit-ios.yml: SAME upstream (webrtc-sdk/webrtc@m144_release),
// SAME LK-symbol-prefixing (apple_prefix.patch, vendored verbatim from
// webrtc-sdk/webrtc-build, the same repo livekit/webrtc-xcframework's own
// README says its releases are built from), PLUS the one-hunk
// aes256-framecryptor.patch this whole fork exists to carry (`DeriveKeys(...,
// password.size()==32?256:128)` — group-call media gets AES-256-GCM instead
// of the upstream AES-128-only FrameCryptor once the app supplies a 32-byte
// shared key). Upstream's own 144.7559.03 tag/release is untouched; this is
// an ADDITIONAL tag on the fork, not a rewrite of history.
let package = Package(
    name: "LiveKitWebRTC",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v14),
    ],
    products: [
        .library(
            name: "LiveKitWebRTC",
            targets: ["LiveKitWebRTC"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "LiveKitWebRTC",
            url: "https://github.com/sigarone/webrtc-aes256-build/releases/download/webrtc-ios-aes256-livekit-m144/LiveKitWebRTC.xcframework.zip",
            checksum: "64b382387b3e976e8054c4a14ac2e0a1bd763846a76b5d94f2c30dcaf6978e88"
        ),
    ]
)
