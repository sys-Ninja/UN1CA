#!/system/bin/sh
# Copyright (c) 2026 sys-Ninja
# Ayah offline assets provisioning script
# Copies preloaded Tafsir databases and Al-Mokhtasar audio commentary on first boot ONLY

LOG() {
    log -p i -t AyahPreload "$1"
}

# 1. Anti-repeat / Single-run check: verify persistent property and flags
FLAG_FILE="/data/media/0/Android/data/com.ayah/.provisioned_v1"
SYS_FLAG="/data/system/.ayah_provisioned"

if [ "$(getprop persist.sys.ayah.provisioned)" = "1" ] || [ -f "$SYS_FLAG" ] || [ -f "$FLAG_FILE" ]; then
    LOG "Ayah assets already provisioned. Exiting."
    exit 0
fi

LOG "Starting Ayah offline assets provisioning (single execution)..."

SRC_DIR="/system/etc/ayah"
if [ ! -d "$SRC_DIR" ]; then
    LOG "Source directory $SRC_DIR does not exist. Aborting."
    exit 1
fi

# 2. Provision Audio into /data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/
TARGET_AUDIO_DIR="/data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
if [ -d "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam" ]; then
    mkdir -p "$TARGET_AUDIO_DIR"
    LOG "Copying genuine audio files to $TARGET_AUDIO_DIR..."
    for f in "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
        [ -f "$f" ] || continue
        fname=$(basename "$f")
        cp -n "$f" "$TARGET_AUDIO_DIR/" 2>/dev/null || true
        # Also create symlink with hyphen format (001-4.mp3 -> 001_4.mp3) with 0 extra disk bytes:
        alt_fname=$(echo "$fname" | sed 's/_4\.mp3/-4\.mp3/')
        if [ "$alt_fname" != "$fname" ] && [ ! -e "$TARGET_AUDIO_DIR/$alt_fname" ]; then
            ln -sf "$fname" "$TARGET_AUDIO_DIR/$alt_fname" 2>/dev/null || true
        fi
    done

    # Ensure /storage/emulated/0 symlink path is also accessible
    if [ -d "/storage/emulated/0/Android/data/com.ayah" ]; then
        mkdir -p "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
        for f in "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
            [ -f "$f" ] || continue
            fname=$(basename "$f")
            cp -n "$f" "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/" 2>/dev/null || true
            alt_fname=$(echo "$fname" | sed 's/_4\.mp3/-4\.mp3/')
            if [ "$alt_fname" != "$fname" ] && [ ! -e "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/$alt_fname" ]; then
                ln -sf "$fname" "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/$alt_fname" 2>/dev/null || true
            fi
        done
    fi
fi

# 3. Provision Tafsir Databases into /data/data/com.ayah/databases and files/
MAX_WAIT=20
WAITED=0
while [ ! -d "/data/data/com.ayah" ] && [ "$WAITED" -lt "$MAX_WAIT" ]; do
    sleep 1
    WAITED=$((WAITED + 1))
done

if [ -d "/data/data/com.ayah" ]; then
    AYAH_UID=$(stat -c '%u' /data/data/com.ayah 2>/dev/null)
    [ -z "$AYAH_UID" ] && AYAH_UID=10000

    mkdir -p /data/data/com.ayah/databases
    mkdir -p /data/data/com.ayah/files

    if [ -d "$SRC_DIR/books" ]; then
        LOG "Copying Tafsir databases..."
        for f in "$SRC_DIR/books/"*.db; do
            [ -f "$f" ] || continue
            bname=$(basename "$f")
            cp -n "$f" /data/data/com.ayah/databases/ 2>/dev/null || true
            cp -n "$f" /data/data/com.ayah/files/ 2>/dev/null || true

            # Create alias symlinks (0 extra bytes) without date for backwards compatibility:
            short_bname=$(echo "$bname" | sed -E 's/-[0-9]{4}-[0-9]{2}-[0-9]{2}//')
            if [ "$short_bname" != "$bname" ]; then
                [ -e "/data/data/com.ayah/databases/$short_bname" ] || ln -sf "$bname" "/data/data/com.ayah/databases/$short_bname" 2>/dev/null || true
                [ -e "/data/data/com.ayah/files/$short_bname" ] || ln -sf "$bname" "/data/data/com.ayah/files/$short_bname" 2>/dev/null || true
            fi
        done
    fi

    chown -R "$AYAH_UID:$AYAH_UID" /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    chmod -R 770 /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    restorecon -R /data/data/com.ayah 2>/dev/null || true
fi

# Fix ownership and permissions for /data/media/0/Android/data/com.ayah
chown -R media_rw:media_rw /data/media/0/Android/data/com.ayah 2>/dev/null || true
chmod -R 775 /data/media/0/Android/data/com.ayah 2>/dev/null || true

# Mark permanently as provisioned so it never runs again
touch "$FLAG_FILE" 2>/dev/null || true
touch "$SYS_FLAG" 2>/dev/null || true
setprop persist.sys.ayah.provisioned 1

LOG "Ayah offline assets provisioning completed successfully. Permanent flag set."
exit 0
