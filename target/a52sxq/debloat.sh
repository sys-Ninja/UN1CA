# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck disable=SC2034

# Debloat list for Galaxy A52s 5G (a52sxq)
# Reclaims space in super partition for offline apps and mods

# Bixby Voice, Services & Routines Agent (System + Product)
SYSTEM_DEBLOAT+="
system/app/BixbyWakeup
system/priv-app/Bixby
system/priv-app/BixbyTouch
system/priv-app/BixbyService
system/priv-app/BixbyAgent
system/priv-app/Rubin
system/priv-app/SystemUIBixby2
system/etc/permissions/privapp-permissions-com.samsung.android.bixby.service.xml
system/etc/permissions/privapp-permissions-com.samsung.android.bixby.agent.xml
system/etc/permissions/privapp-permissions-com.samsung.android.app.spage.xml
system/etc/permissions/privapp-permissions-com.samsung.android.rubin.app.xml
"

PRODUCT_DEBLOAT+="
app/BixbyWakeup
priv-app/Bixby
priv-app/BixbyTouch
priv-app/BixbyService
priv-app/BixbyAgent
priv-app/Rubin
priv-app/SystemUIBixby2
etc/permissions/privapp-permissions-com.samsung.android.bixby.service.xml
etc/permissions/privapp-permissions-com.samsung.android.bixby.agent.xml
etc/permissions/privapp-permissions-com.samsung.android.app.spage.xml
etc/permissions/privapp-permissions-com.samsung.android.rubin.app.xml
"

# Samsung Kids (optional child sandbox launcher)
SYSTEM_DEBLOAT+="
system/priv-app/KidsHome
system/app/KidsInstaller
system/etc/permissions/privapp-permissions-com.sec.android.app.kidshome.xml
"

PRODUCT_DEBLOAT+="
priv-app/KidsHome
app/KidsInstaller
etc/permissions/privapp-permissions-com.sec.android.app.kidshome.xml
"

# Samsung Tips & AR Zone
SYSTEM_DEBLOAT+="
system/app/Tips
system/app/ARZone
system/app/DecoPic
system/app/LiveStickers
system/priv-app/AREmojiEditor
system/priv-app/AvatarEmojiSticker
"

PRODUCT_DEBLOAT+="
app/Tips
app/ARZone
app/DecoPic
app/LiveStickers
app/AREmoji
priv-app/AREmojiEditor
priv-app/AvatarEmojiSticker
"

# Samsung Global Goals
PRODUCT_DEBLOAT+="
app/GlobalGoals
"
