# Copyright (c) 2026 sys-Ninja
# SPDX-License-Identifier: GPL-3.0-or-later
# shellcheck disable=SC2034

# Debloat list for Galaxy A52s 5G (a52sxq)
# Verified real paths extracted directly from running A52s device via ADB
# Reclaims space in super partition for offline apps and mods

# Bixby Voice, Interpreter & Routines Agent (Verified paths from device)
SYSTEM_DEBLOAT+="
system/app/BixbyWakeup
system/priv-app/Bixby
system/priv-app/SamsungIntelliVoiceServices
system/priv-app/BixbyInterpreter
system/priv-app/RubinVersion37
system/priv-app/BixbyVisionFramework3.5
"

# Samsung Kids Installer Stub
SYSTEM_DEBLOAT+="
system/app/KidsHome_Installer
"

# Google App & Speech in Product (Freely installable from Play Store, saves 250MB)
PRODUCT_DEBLOAT+="
priv-app/Velvet
app/SpeechServicesByGoogle
"
