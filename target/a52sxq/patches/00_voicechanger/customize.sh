LOG_STEP_IN "- Installing the call voice changer"

if [ ! -f "$MODPATH/system/bin/vc_daemon" ]; then
    LOGE "Missing $MODPATH/system/bin/vc_daemon"
    LOGE "Build it first: scripts/build_vc_daemon.sh (CI does this in the \"daemon\" job)"
    exit 1
fi

LOG "- Setting metadata"
SET_METADATA "system" "system/bin/vc_daemon" 0 0 755 "u:object_r:vc_daemon_exec:s0"
SET_METADATA "system" "system/etc/init/vc_daemon.rc" 0 0 644 "u:object_r:system_file:s0"

LOG "- Patching /vendor/etc/selinux/vendor_sepolicy.cil"
cat >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" << 'CIL'
(type vc_daemon)
(typeattributeset domain (vc_daemon))
(roletype object_r vc_daemon)
(type vc_daemon_exec)
(typeattributeset file_type (vc_daemon_exec))
(typeattributeset exec_type (vc_daemon_exec))
(roletype object_r vc_daemon_exec)
(allow init_30_0 vc_daemon_exec (file (read getattr open map execute)))
(allow init_30_0 vc_daemon (process (transition noatsecure siginh rlimitinh sigkill signal sigstop)))
(typepermissive vc_daemon)
CIL

LOG_STEP_OUT
