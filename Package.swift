// swift-tools-version:5.9
// (Xcode15.0+)

import PackageDescription

// AES-256 fork (sigarone/webrtc-xcframework, branch aes256-livekit, tag
// 144.7559.10-aes256-livekit-native-pli-2) — points the binaryTarget at a
// drop-in LiveKitWebRTC.xcframework built by sigarone/webrtc-aes256-build's
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
// Bumped 2026-08-26 (again, -native-pli -> -native-pli-2): the first
// -native-pli build was missing Headers/RTCAudioProcessingState.h
// (confirmed by diffing the release zip's Headers/ listing against the
// prior known-good 144.7559.10-aes256-livekit build) because
// build-livekit-ios.yml's `webrtc_ref` workflow_dispatch DEFAULT had gone
// stale — it read a tag pinned to a 2026-03-30 sigarone/webrtc commit that
// predates upstream adding that header, while the actual known-good build
// below was produced by manually overriding that input to
// f47af7bc9658-livekit-aes256-7559.10 (2026-06-15) and the YAML default was
// never updated to match. Fixed at the source: build-livekit-ios.yml's
// default is now re-pinned to f47af7bc9658-livekit-aes256-7559.10 itself
// (see that repo's commit 506c59d), so this rebuild uses the exact same
// upstream commit as the known-good one. Re-verified after rebuilding:
// LiveKitWebRTC.xcframework.zip's Headers/ listing now matches the
// known-good build byte-for-byte (112/112 files, RTCAudioProcessingState.h
// included) — not just a green CI checkmark. Same native-pli.patch
// (W-NATIVEPLI) content as the reverted -native-pli tag, no patch changes.
//
// Bumped 2026-08-26 (superseded by the above): same 144.7559.10 WebRTC
// source, ADDED native-pli.patch (W-NATIVEPLI) — the unconditional,
// rate-limited FrameCryptionState.kDecryptionFailed notification on a real
// decrypt-tag-mismatch, ported from Android's 2026-08-25 AAR rebuild to
// close the group-call iOS/Android parity gap (see qaudion-android-new's
// `project_aar_rebuild_2026_08_25` and qaudion-ios's
// `project_aar_ios_parity_audit_2026_08_26` memory files). No source/
// version change beyond that one added patch.
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
            url: "https://github.com/sigarone/webrtc-aes256-build/releases/download/webrtc-ios-aes256-livekit-m144-native-pli-2/LiveKitWebRTC.xcframework.zip",
            checksum: "b7a999c1ceb087dc818b28f9d65923e62e7d7b17bfcb8e78ed497eed9e14e96e"
        ),
    ]
)
