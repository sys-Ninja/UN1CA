# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Galaxy A52s 5G (a52sxq)
# Reclaims space in super partition for offline apps and mods

# Bixby Voice, Services & Routines Agent
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

# Samsung Kids (optional child sandbox launcher)
SYSTEM_DEBLOAT+="
system/priv-app/KidsHome
system/app/KidsInstaller
system/etc/permissions/privapp-permissions-com.sec.android.app.kidshome.xml
"

# Samsung Tips & AR Zone
SYSTEM_DEBLOAT+="
system/app/Tips
system/app/ARZone
system/app/DecoPic
system/app/LiveStickers
"
