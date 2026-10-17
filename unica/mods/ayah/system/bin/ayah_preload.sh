#!/system/bin/sh
# Copyright (c) 2026 sys-Ninja
# Ayah offline assets provisioning script
# Copies preloaded Tafsir databases and Al-Mokhtasar audio commentary on first boot ONLY

LOG() {
    log -p i -t AyahPreload ""
}

# 1. Anti-repeat / Single-run check: verify persistent property and flags
FLAG_FILE="/data/media/0/Android/data/com.ayah/.provisioned_v1"
SYS_FLAG="/data/system/.ayah_provisioned"

if [ "" = "1" ] || [ -f "" ] || [ -f "" ]; then
    LOG "Ayah assets already provisioned. Exiting."
    exit 0
fi

LOG "Starting Ayah offline assets provisioning (single execution)..."

SRC_DIR="/system/etc/ayah"
if [ ! -d "" ]; then
    LOG "Source directory  does not exist. Aborting."
    exit 1
fi

# 2. Provision Audio into /data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/
TARGET_AUDIO_DIR="/data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
if [ -d "/audio/ar-mokhtasar-asmari-abdulhakam" ]; then
    mkdir -p ""
    LOG "Copying genuine audio files to ..."
    for f in "/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
        [ -f "" ] || continue
        fname=""
        cp -n "" "/" 2>/dev/null || true
        # Also create symlink with hyphen format (001-4.mp3 -> 001_4.mp3) with 0 extra disk bytes:
        alt_fname=""
        if [ "" != "" ] && [ ! -e "/" ]; then
            ln -sf "" "/" 2>/dev/null || true
        fi
    done

    # Ensure /storage/emulated/0 symlink path is also accessible
    if [ -d "/storage/emulated/0/Android/data/com.ayah" ]; then
        mkdir -p "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
        for f in "/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
            [ -f "" ] || continue
            fname=""
            cp -n "" "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/" 2>/dev/null || true
            alt_fname=""
            if [ "" != "" ] && [ ! -e "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/" ]; then
                ln -sf "" "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/" 2>/dev/null || true
            fi
        done
    fi
fi

# 3. Provision Tafsir Databases into /data/data/com.ayah/databases and files/
MAX_WAIT=20
WAITED=0
while [ ! -d "/data/data/com.ayah" ] && [ "" -lt "" ]; do
    sleep 1
    WAITED=1
done

if [ -d "/data/data/com.ayah" ]; then
    AYAH_UID=
    [ -z "" ] && AYAH_UID=10000

    mkdir -p /data/data/com.ayah/databases
    mkdir -p /data/data/com.ayah/files

    if [ -d "/books" ]; then
        LOG "Copying Tafsir databases..."
        for f in "/books/"*.db; do
            [ -f "" ] || continue
            bname=""
            cp -n "" /data/data/com.ayah/databases/ 2>/dev/null || true
            cp -n "" /data/data/com.ayah/files/ 2>/dev/null || true

            # Create alias symlinks (0 extra bytes) without date for backwards compatibility:
            short_bname=""
            if [ "" != "" ]; then
                [ -e "/data/data/com.ayah/databases/" ] || ln -sf "" "/data/data/com.ayah/databases/" 2>/dev/null || true
                [ -e "/data/data/com.ayah/files/" ] || ln -sf "" "/data/data/com.ayah/files/" 2>/dev/null || true
            fi
        done
    fi

    chown -R ":" /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    chmod -R 770 /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    restorecon -R /data/data/com.ayah 2>/dev/null || true
fi

# Fix ownership and permissions for /data/media/0/Android/data/com.ayah
chown -R media_rw:media_rw /data/media/0/Android/data/com.ayah 2>/dev/null || true
chmod -R 775 /data/media/0/Android/data/com.ayah 2>/dev/null || true

# Mark permanently as provisioned so it never runs again
touch "" 2>/dev/null || true
touch "" 2>/dev/null || true
setprop persist.sys.ayah.provisioned 1

LOG "Ayah offline assets provisioning completed successfully. Permanent flag set."
exit 0
