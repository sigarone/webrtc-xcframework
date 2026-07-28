// swift-tools-version:5.9
// (Xcode15.0+)

import PackageDescription

// AES-256 fork (sigarone/webrtc-xcframework, branch aes256-livekit, tag
// 144.7559.10-aes256-livekit) — points the binaryTarget at a drop-in
// LiveKitWebRTC.xcframework built by sigarone/webrtc-aes256-build's
// build-livekit-ios.yml: SAME LK-symbol-prefixing (apple_prefix.patch,
// vendored verbatim from webrtc-sdk/webrtc-build, the same repo
// livekit/webrtc-xcframework's own README says its releases are built
// from), PLUS the one-hunk aes256-framecryptor.patch this whole fork
// exists to carry (`DeriveKeys(..., password.size()==32?256:128)` —
// group-call media gets AES-256-GCM instead of the upstream
// AES-128-only FrameCryptor once the app supplies a 32-byte shared
// key). Upstream's own 144.7559.10 tag/release is untouched; this is
// an ADDITIONAL tag on the fork, not a rewrite of history.
//
// Bumped 2026-07-28 from 144.7559.03 to 144.7559.10 (to unblock
// client-sdk-swift 2.13.1-aes256-raw -> 2.15.1-aes256-raw, which
// upstream pins exactly to this webrtc-xcframework version). Built
// from sigarone/webrtc@f47af7bc9658 (tagged
// f47af7bc9658-livekit-aes256-7559.10 on the webrtc fork) — one day
// before livekit/webrtc-xcframework's real 144.7559.10 cut
// (2026-06-16), same day-prior matching methodology already validated
// for 144.7559.03 (see that build's own history above). Verified in
// the build log: LK-prefixed symbols present
// (_OBJC_CLASS_$_LKRTCPeerConnection etc.) and "AES-256 GCM using
// openssl" string present in the binary.
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
            url: "https://github.com/sigarone/webrtc-aes256-build/releases/download/webrtc-ios-aes256-livekit-m144-7559.10/LiveKitWebRTC.xcframework.zip",
            checksum: "1857a77569cc43b48ab31717a1738edc0a6c81feafc3eee5d581acc818fb0564"
        ),
    ]
)
