#!/usr/bin/env bash
# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

SRC_DIR="$(dirname "$(readlink -f "$0")")/.."
APP_DIR="$SRC_DIR/unica/apps/antipeeping"
OUT_APK="$SRC_DIR/unica/mods/v_antipeeping/system/priv-app/UnicaAntiPeeping/UnicaAntiPeeping.apk"

SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
if [ -z "$SDK" ] || [ ! -d "$SDK" ]; then
    echo "Android SDK not found. Set ANDROID_HOME or ANDROID_SDK_ROOT." >&2
    exit 1
fi

BUILD_TOOLS="$(find "$SDK/build-tools" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)"
if [ -z "$BUILD_TOOLS" ]; then
    echo "Android build-tools not found in $SDK/build-tools." >&2
    exit 1
fi
echo "Build-tools: $BUILD_TOOLS"
echo "Output:      $OUT_APK"

if [ -x "$APP_DIR/gradlew" ]; then
    GRADLE_CMD="$APP_DIR/gradlew"
else
    GRADLE_BIN="$(command -v gradle || true)"
    if [ -z "$GRADLE_BIN" ]; then
        GRADLE_VERSION="8.9"
        GRADLE_HOME="$SRC_DIR/out/gradle-$GRADLE_VERSION"
        if [ ! -x "$GRADLE_HOME/bin/gradle" ]; then
            echo "Downloading Gradle $GRADLE_VERSION..."
            mkdir -p "$SRC_DIR/out"
            curl -fsSL -o "$SRC_DIR/out/gradle.zip" \
                "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
            unzip -q -o "$SRC_DIR/out/gradle.zip" -d "$SRC_DIR/out"
            rm -f "$SRC_DIR/out/gradle.zip"
        fi
        GRADLE_BIN="$GRADLE_HOME/bin/gradle"
    fi
    GRADLE_CMD="$GRADLE_BIN"
fi

(cd "$APP_DIR" && "$GRADLE_CMD" --no-daemon assembleRelease)

UNSIGNED="$APP_DIR/app/build/outputs/apk/release/app-release-unsigned.apk"
[ -f "$UNSIGNED" ] || UNSIGNED="$APP_DIR/app/build/outputs/apk/release/app-release.apk"
if [ ! -f "$UNSIGNED" ]; then
    echo "Gradle output APK not found." >&2
    exit 1
fi

CERT_PREFIX="aosp"
if [ -s "$SRC_DIR/security/unica_platform.pk8" ] && \
        [ -s "$SRC_DIR/security/unica_platform.x509.pem" ]; then
    CERT_PREFIX="unica"
fi
echo "Signing with ${CERT_PREFIX}_platform key"

ALIGNED="$APP_DIR/app/build/outputs/apk/release/aligned.apk"
"$BUILD_TOOLS/zipalign" -f -p 4 "$UNSIGNED" "$ALIGNED"

mkdir -p "$(dirname "$OUT_APK")"
"$BUILD_TOOLS/apksigner" sign \
    --key "$SRC_DIR/security/${CERT_PREFIX}_platform.pk8" \
    --cert "$SRC_DIR/security/${CERT_PREFIX}_platform.x509.pem" \
    --out "$OUT_APK" \
    "$ALIGNED"

echo "Done: $OUT_APK"