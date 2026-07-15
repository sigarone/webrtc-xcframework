// swift-tools-version:5.9
// (Xcode15.0+)

import PackageDescription

// AES-256 fork (sigarone/webrtc-xcframework, branch aes256-livekit, tag
// 144.7559.03-aes256-livekit) — points the binaryTarget at a drop-in
// LiveKitWebRTC.xcframework built by sigarone/webrtc-aes256-build's
// build-livekit-ios.yml: SAME LK-symbol-prefixing (apple_prefix.patch,
// vendored verbatim from webrtc-sdk/webrtc-build, the same repo
// livekit/webrtc-xcframework's own README says its releases are built
// from), PLUS the one-hunk aes256-framecryptor.patch this whole fork
// exists to carry (`DeriveKeys(..., password.size()==32?256:128)` —
// group-call media gets AES-256-GCM instead of the upstream
// AES-128-only FrameCryptor once the app supplies a 32-byte shared
// key). Upstream's own 144.7559.03 tag/release is untouched; this is
// an ADDITIONAL tag on the fork, not a rewrite of history.
//
// Checksum updated (2026-07-15/16): the FIRST build used
// webrtc_ref=m144_release (a rolling branch), whose tip had drifted
// ~2.5 months past livekit/webrtc-xcframework's real 144.7559.03 cut
// and broke client-sdk-swift 2.13.0's compile (LKRTCAudioDeviceModule
// missing isVoiceProcessingEnabled — see build-livekit-ios.yml's own
// comment). Rebuilt from the exact pinned commit
// (sigarone/webrtc@770e5461892d, tagged 770e5461892d-livekit-aes256)
// and republished to the SAME release asset URL — only the checksum
// below changed to match the new (correct) zip.
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
            checksum: "9074b67003139f13537114af8800cfc2b15b2e6a09f829e3e8c4774d7c1b6176"
        ),
    ]
)
