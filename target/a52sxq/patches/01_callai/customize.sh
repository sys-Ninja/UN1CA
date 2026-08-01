LOG_STEP_IN "- Installing AI call answering"

if [ ! -f "$MODPATH/system/bin/ca_daemon" ]; then
    LOGE "Missing $MODPATH/system/bin/ca_daemon"
    LOGE "Build it first: scripts/build_ca_daemon.sh (CI does this in the \"daemon\" job)"
    exit 1
fi

LOG "- Setting metadata"
SET_METADATA "system" "system/bin/ca_daemon" 0 0 755 "u:object_r:ca_daemon_exec:s0"
SET_METADATA "system" "system/etc/init/ca_daemon.rc" 0 0 644 "u:object_r:system_file:s0"

LOG "- Patching /vendor/etc/selinux/vendor_sepolicy.cil"
cat >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" << 'CIL'
(type ca_daemon)
(typeattributeset domain (ca_daemon))
(roletype object_r ca_daemon)
(type ca_daemon_exec)
(typeattributeset file_type (ca_daemon_exec))
(typeattributeset exec_type (ca_daemon_exec))
(roletype object_r ca_daemon_exec)
(allow init_30_0 ca_daemon_exec (file (read getattr open map execute)))
(allow init_30_0 ca_daemon (process (transition noatsecure siginh rlimitinh sigkill signal sigstop)))
(allow platform_app ca_daemon (unix_stream_socket (connectto)))
(allow system_app ca_daemon (unix_stream_socket (connectto)))
(typepermissive ca_daemon)
CIL

LOG_STEP_OUT
