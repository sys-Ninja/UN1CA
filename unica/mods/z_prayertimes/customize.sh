# shellcheck disable=SC2034
SKIPUNZIP=1

# Guard: fail loudly if the APK was not placed here by the build system.
# In CI this file is downloaded from the 'prayertimes' job artifact before
# make_rom.sh runs.  Locally, run ./scripts/build_prayertimes_apk.sh first.
if [ ! -f "$MODPATH/system/priv-app/UnicaPrayerTimes/UnicaPrayerTimes.apk" ]; then
    LOGE "UnicaPrayerTimes.apk not found at $MODPATH/system/priv-app/UnicaPrayerTimes/"
    LOGE "Run ./scripts/build_prayertimes_apk.sh and retry."
    return 1
fi

# ── Add entire system tree (APK + permissions XMLs) ───────────────────────────
ADD_TO_WORK_DIR "$MODPATH" "system" "." 0 0 755 "u:object_r:system_file:s0"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

# Dynamically patch SecSettings
while IFS= read -r f; do
    f="${f//$MODPATH\/SecSettings.apk\//}"

    if [ ! -f "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f" ] || \
            [[ "$f" != *".xml" ]]; then
        LOG "- Adding \"$f\" to /system/system/priv-app/SecSettings.apk"
        EVAL "mkdir -p \"$(dirname "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f")\""
        EVAL "cp -a \"$MODPATH/SecSettings.apk/${f//\$/\\\$}\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/${f//\$/\\\$}\""
    else
        LOG "- Patching \"$f\" in /system/system/priv-app/SecSettings.apk"
        if [[ "$f" == *"res/values"* ]]; then
            PATCH_INST="/<\/resources>/i"
            CONTENT="$(sed -e "/?xml/d" -e "/resources>/d" "$MODPATH/SecSettings.apk/$f")"
        else
            PATCH_INST="$(head -n 1 "$MODPATH/SecSettings.apk/$f")"
            CONTENT="$(tail -n +2 "$MODPATH/SecSettings.apk/$f")"
        fi
        CONTENT="$(sed -e "s/\"/\\\\\"/g" -e "s/\\\$/$\\\$/g" -e "s/ /\\ /g" -e "s/\\\\n/\\\\\\\n/g" <<< "$CONTENT")"
        CONTENT="$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' <<< "$CONTENT")"
        EVAL "sed -i \"$PATCH_INST $CONTENT\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f\""
    fi
done < <(find "$MODPATH/SecSettings.apk" -type f)

unset PATCH_INST CONTENT
