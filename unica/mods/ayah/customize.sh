#!/usr/bin/env bash
# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck disable=SC2034
SKIPUNZIP=1

if [ ! -f "$MODPATH/system/app/Ayah/Ayah.apk" ]; then
    LOGE "Ayah.apk not found at $MODPATH/system/app/Ayah/Ayah.apk"
    LOGE "Run python3 scripts/download_ayah_offline.py before building."
    return 1
fi

ADD_TO_WORK_DIR "$MODPATH" "system" "." 0 0 755 "u:object_r:system_file:s0"
