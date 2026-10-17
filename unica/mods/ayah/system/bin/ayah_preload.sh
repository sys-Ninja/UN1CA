#!/system/bin/sh
# Copyright (c) 2026 sys-Ninja
# Ayah offline assets provisioning script
# Copies preloaded Tafsir databases and Al-Mokhtasar audio commentary on first boot

FLAG_FILE="/data/media/0/Android/data/com.ayah/.provisioned_v1"

if [ -f "$FLAG_FILE" ]; then
    exit 0
fi

LOG() {
    log -p i -t AyahPreload "$1"
}

LOG "Starting Ayah offline assets provisioning..."

SRC_DIR="/system/etc/ayah"
if [ ! -d "$SRC_DIR" ]; then
    LOG "Source directory $SRC_DIR does not exist. Aborting."
    exit 1
fi

# 1. Provision Audio: /data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/
TARGET_AUDIO_DIR="/data/media/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
if [ -d "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam" ]; then
    mkdir -p "$TARGET_AUDIO_DIR"
    LOG "Copying audio files to $TARGET_AUDIO_DIR..."
    for f in "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
        [ -f "$f" ] || continue
        cp -n "$f" "$TARGET_AUDIO_DIR/" 2>/dev/null || true
    done

    if [ -d "/storage/emulated/0/Android/data/com.ayah" ]; then
        mkdir -p "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam"
        for f in "$SRC_DIR/audio/ar-mokhtasar-asmari-abdulhakam/"*.mp3; do
            [ -f "$f" ] || continue
            cp -n "$f" "/storage/emulated/0/Android/data/com.ayah/files/audio/ar-mokhtasar-asmari-abdulhakam/" 2>/dev/null || true
        done
    fi
fi

# 2. Provision Tafsir Databases: /data/data/com.ayah/databases/ and /data/data/com.ayah/files/
MAX_WAIT=30
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
        LOG "Copying Tafsir databases to /data/data/com.ayah/databases and files..."
        for f in "$SRC_DIR/books/"*.db; do
            [ -f "$f" ] || continue
            cp -f "$f" /data/data/com.ayah/databases/ 2>/dev/null || true
            cp -f "$f" /data/data/com.ayah/files/ 2>/dev/null || true
        done
    fi

    chown -R "$AYAH_UID:$AYAH_UID" /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    chmod -R 770 /data/data/com.ayah/databases /data/data/com.ayah/files 2>/dev/null || true
    restorecon -R /data/data/com.ayah 2>/dev/null || true
fi

# Set proper ownership and permissions for Android/data
chown -R media_rw:media_rw /data/media/0/Android/data/com.ayah 2>/dev/null || true
chmod -R 775 /data/media/0/Android/data/com.ayah 2>/dev/null || true

# Mark as provisioned
touch "$FLAG_FILE"
LOG "Ayah offline assets provisioning completed successfully."
exit 0
