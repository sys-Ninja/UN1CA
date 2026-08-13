# shellcheck disable=SC2034
SKIPUNZIP=1

if [ ! -f "$MODPATH/system/priv-app/UnicaDownloader/UnicaDownloader.apk" ]; then
    LOG "\033[0;33m! UnicaDownloader.apk not found. Skipping\033[0m"
    return 0
fi

ADD_TO_WORK_DIR "$MODPATH" "system" "." 0 0 755 "u:object_r:system_file:s0"

# ── Extract native libs so Android can execute them from priv-app ──────────────
# priv-app APKs are NOT unpacked automatically; we pre-extract and set correct
# permissions (libpython.so needs +x as it is the Python interpreter binary).
LOG "- Extracting native libraries from UnicaDownloader.apk"
APK_PATH="$WORK_DIR/system/system/priv-app/UnicaDownloader/UnicaDownloader.apk"
LIB_DIR="$WORK_DIR/system/system/priv-app/UnicaDownloader/lib/arm64"
mkdir -p "$LIB_DIR"
unzip -o "$APK_PATH" 'lib/arm64-v8a/*' -d /tmp/unica_dl_extract/ > /dev/null 2>&1
if [ -d "/tmp/unica_dl_extract/lib/arm64-v8a" ]; then
    cp /tmp/unica_dl_extract/lib/arm64-v8a/* "$LIB_DIR/"
    # libpython.so is the Python interpreter — must be executable
    chmod 755 "$LIB_DIR/libpython.so"
    # all other .so files are shared libraries, not executables
    chmod 644 "$LIB_DIR/libffmpeg.so" \
               "$LIB_DIR/libffmpeg.zip.so" \
               "$LIB_DIR/libffprobe.so" \
               "$LIB_DIR/libpython.zip.so" \
               "$LIB_DIR/libqjs.so" 2>/dev/null || true
    LIB_COUNT=$(find "$LIB_DIR" -maxdepth 1 -name "*.so" | wc -l)
    LOG "- Extracted ${LIB_COUNT} native lib(s) to lib/arm64 (libpython.so +x)"
else
    LOG "\033[0;33m! No arm64-v8a libs found in APK\033[0m"
fi
rm -rf /tmp/unica_dl_extract/

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
        CONTENT="$(sed -e "s/\"/\\\\\"/g" -e "s/\\$/\\\\$/g" -e "s/ /\\\ /g" -e "s/\\\\n/\\\\\\\\\n/g" <<< "$CONTENT")"
        CONTENT="$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' <<< "$CONTENT")"
        EVAL "sed -i \"$PATCH_INST $CONTENT\" \"$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk/$f\""
    fi
done < <(find "$MODPATH/SecSettings.apk" -type f)

unset PATCH_INST CONTENT