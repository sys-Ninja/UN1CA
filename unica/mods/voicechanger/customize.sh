LOG_STEP_IN "- Installing the universal HAL voice changer"

if [ ! -f "$MODPATH/system/lib64/libvoicechanger.so" ]; then
    LOGE "Missing $MODPATH/system/lib64/libvoicechanger.so"
    LOGE "Build it first: scripts/build_voicechanger_hal.sh"
    exit 1
fi

LOG "- Setting metadata"
SET_METADATA "system" "system/lib64/libvoicechanger.so" 0 0 644 "u:object_r:system_file:s0"

LOG "- Exporting persist.sys.unica.vc.* properties to untrusted_app domain"
for PROP_CTX in \
        "$WORK_DIR/vendor/etc/selinux/vendor_property_contexts" \
        "$WORK_DIR/system/etc/selinux/plat_property_contexts"; do
    if [ -f "$PROP_CTX" ]; then
        sed -i '/^persist\.sys\.unica\.vc\./d' "$PROP_CTX"
        printf 'persist.sys.unica.vc.    u:object_r:exported_system_prop:s0\n' >> "$PROP_CTX"
        LOG "  -> patched $PROP_CTX"
    fi
done
unset PROP_CTX

LOG_STEP_OUT
