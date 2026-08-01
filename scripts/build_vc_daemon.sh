#!/usr/bin/env bash
# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Cross-compiles the call voice changer daemon for arm64 and drops the binary
# into the ROM module so apply_modules.sh can pick it up.
#
# Requires the Android NDK. Set ANDROID_NDK_HOME, or let the script fall back to
# $ANDROID_SDK_ROOT/ndk/<latest>.

set -e

SRC_DIR="$(dirname "$(readlink -f "$0")")/.."
MODULE_DIR="$SRC_DIR/target/a52sxq/patches/00_voicechanger"
API_LEVEL=31

FIND_NDK()
{
    if [ -n "$ANDROID_NDK_HOME" ] && [ -d "$ANDROID_NDK_HOME" ]; then
        echo "$ANDROID_NDK_HOME"
        return 0
    fi

    local SDK="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-$HOME/Android/Sdk}}"
    if [ -d "$SDK/ndk" ]; then
        find "$SDK/ndk" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1
        return 0
    fi

    return 1
}

NDK="$(FIND_NDK)"
if [ -z "$NDK" ] || [ ! -d "$NDK" ]; then
    echo "Android NDK not found. Set ANDROID_NDK_HOME." >&2
    exit 1
fi

CC="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android$API_LEVEL-clang"
if [ ! -x "$CC" ]; then
    echo "Compiler not found: $CC" >&2
    exit 1
fi

echo "NDK:    $NDK"
echo "Output: $MODULE_DIR/system/bin/vc_daemon"

mkdir -p "$MODULE_DIR/system/bin"
"$CC" -O2 -Wall -Wextra -ffast-math \
    -o "$MODULE_DIR/system/bin/vc_daemon" \
    "$MODULE_DIR/src/vc_daemon.c" \
    "$MODULE_DIR/src/sonic.c" \
    -ldl -lm -llog

"$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip" \
    "$MODULE_DIR/system/bin/vc_daemon"

file "$MODULE_DIR/system/bin/vc_daemon"

exit 0
