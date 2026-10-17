if $DEBUG; then
    LOG "\033[0;33m! Debug build detected. Skipping\033[0m"
    return 0
fi

# [
COMPRESS_WEBP()
{
    local FILE="$1"
    local FILE_PATH
    local FILE_NAME
    local RES="2400"
    local CMD

    FILE_PATH="$(dirname "$FILE")"
    FILE_NAME="$(basename "$FILE")"

    if $TARGET_COMMON_SUPPORT_DYN_RESOLUTION_CONTROL; then
        if [ "$TARGET_PRODUCT_SHIPPING_API_LEVEL" -gt "30" ] && \
                [ "$TARGET_PRODUCT_SHIPPING_API_LEVEL" -lt "34" ]; then
            RES="3088"
        else
            RES="3120"
        fi
    fi

    LOG "- Compressing $FILE_NAME"

    CMD="cwebp"
    CMD+=" -q 100"
    CMD+=" -resize $RES $RES"
    CMD+=" \"$FILE_PATH/$FILE_NAME\""
    CMD+=" -o \"$FILE_PATH/temp.webp\""

    EVAL "$CMD" || return 1
    EVAL "mv -f \"$FILE_PATH/temp.webp\" \"$FILE_PATH/$FILE_NAME\"" || return 1
}

ENCODE_MP4()
{
    local FILE="$1"
    local FILE_PATH
    local FILE_NAME
    local RES="-1:2400"
    local CMD

    FILE_PATH="$(dirname "$FILE")"
    FILE_NAME="$(basename "$FILE")"

    if $TARGET_COMMON_SUPPORT_DYN_RESOLUTION_CONTROL; then
        RES="1440:-1"
    fi

    LOG "- Encoding $FILE_NAME"

    CMD="ffmpeg"
    CMD+=" -i \"$FILE_PATH/$FILE_NAME\""
    CMD+=" -c:v libx264 -c:a copy"
    CMD+=" -pix_fmt yuv420p -crf 18 -g 1"
    CMD+=" -preset veryslow -tune zerolatency"
    CMD+=" -movflags use_metadata_tags -map_metadata 0"
    CMD+=" -vf \"fps=60,scale=$RES,setsar=1:1\""
    CMD+=" -video_track_timescale 360000 -movie_timescale 90000"
    CMD+=" \"$FILE_PATH/temp.mp4\""

    EVAL "$CMD" || return 1
    EVAL "mv -f \"$FILE_PATH/temp.mp4\" \"$FILE_PATH/$FILE_NAME\"" || return 1
}
# ]

ADD_TO_WORK_DIR "pa2qxxx" "system" \
    "system/priv-app/wallpaper-res/wallpaper-res.apk" 0 0 644 "u:object_r:system_file:s0"
DECODE_APK "system" "system/priv-app/wallpaper-res/wallpaper-res.apk"
for f in "$APKTOOL_DIR/system/priv-app/wallpaper-res/wallpaper-res.apk/res/drawable-nodpi/dex_wallpaper_"*.webp; do
    COMPRESS_WEBP "$f"
done
for f in "$APKTOOL_DIR/system/priv-app/wallpaper-res/wallpaper-res.apk/res/drawable-nodpi/wallpaper_"*.webp; do
    COMPRESS_WEBP "$f"
done
if [ -d "$MODPATH/assets" ]; then
    LOG "- Adding custom wallpapers"
    for wallpaper_file in "$MODPATH/assets/"*.webp; do
        [ -f "$wallpaper_file" ] || continue
        COMPRESS_WEBP "$wallpaper_file"
        cp -f "$wallpaper_file" \
            "$APKTOOL_DIR/system/priv-app/wallpaper-res/wallpaper-res.apk/res/drawable-nodpi/"
    done
fi
for f in "$APKTOOL_DIR/system/priv-app/wallpaper-res/wallpaper-res.apk/res/raw/video_"*.mp4; do
    ENCODE_MP4 "$f"
done
LOG "- Downloading latest Samsung Wallpaper app"
DOWNLOAD_FILE "$(GET_GALAXY_STORE_DOWNLOAD_URL "000008552712")" \
    "$WORK_DIR/system/system/priv-app/SpriteWallpaper/SpriteWallpaper.apk"
APPLY_PATCH "system" "system/priv-app/SpriteWallpaper/SpriteWallpaper.apk" \
    "$MODPATH/SpriteWallpaper.apk/0001-Force-Paradigm-wallpapers-motion-animator.patch"
APPLY_PATCH "system" "system/priv-app/SpriteWallpaper/SpriteWallpaper.apk" \
    "$MODPATH/SpriteWallpaper.apk/0002-Adjust-motion-animator-for-60fps-video-files.patch"
APPLY_PATCH "system" "system/priv-app/wallpaper-res/wallpaper-res.apk" \
    "$MODPATH/wallpaper-res.apk/0001-Adjust-metadata-for-60fps-video-files.patch"

LOG "- Updating wallpaper JSONs with custom wallpapers (Featured, Graphical, Legacy)"
python3 -c "
import json, os

raw_dir = os.path.join(os.environ.get('APKTOOL_DIR', ''), 'system/priv-app/wallpaper-res/wallpaper-res.apk/res/raw')

# 1. Update resources_info.json (Legacy / DeX)
f_main = os.path.join(raw_dir, 'resources_info.json')
if os.path.isfile(f_main):
    with open(f_main, 'r', encoding='utf-8') as f:
        d = json.load(f)
    phone = d.setdefault('phone', [])
    existing = {x.get('filename') for x in phone}
    cur_idx = len(phone)
    for num in range(11, 21):
        fname = f'wallpaper_{num}.png'
        if fname not in existing:
            phone.append({
                'isDefault': False,
                'index': cur_idx,
                'which': 3,
                'screen': 0,
                'type': 0,
                'filename': fname,
                'frame_no': -1,
                'desc_str_id': 'str_id_silver',
                'cmf_info': ['']
            })
            cur_idx += 1
    with open(f_main, 'w', encoding='utf-8') as f:
        json.dump(d, f, indent=2)

# 2. Update resources_info_feature.json (Featured category in One UI 6/7 DressRoom)
f_feat = os.path.join(raw_dir, 'resources_info_feature.json')
if os.path.isfile(f_feat):
    with open(f_feat, 'r', encoding='utf-8') as f:
        d = json.load(f)
    feat_list = d.setdefault('feature', [])
    existing = {x.get('filename') for x in feat_list}
    cur_idx = len(feat_list)
    for num in range(11, 21):
        fname = f'wallpaper_{num}'
        if fname not in existing:
            feat_list.append({
                'index': cur_idx,
                'type': 12,
                'category': 'feature_recommended',
                'filename': fname,
                'preset_content_id': str(num),
                'desc_str_id': 'str_id_graphical_cloud_shape',
                'type_params': {
                    'clock_face_type': 1,
                    'clock_font_color': 1,
                    'clock_font_color_custom': '#fffafafa'
                },
                'logging_info': {
                    'custom_dimens': {
                        'Featured': 'Graphical'
                    }
                }
            })
            cur_idx += 1
    with open(f_feat, 'w', encoding='utf-8') as f:
        json.dump(d, f, indent=2)

# 3. Update resources_info_graphic.json (Graphical category in One UI 6/7 DressRoom)
f_graph = os.path.join(raw_dir, 'resources_info_graphic.json')
if os.path.isfile(f_graph):
    with open(f_graph, 'r', encoding='utf-8') as f:
        d = json.load(f)
    phone = d.setdefault('phone', [])
    existing = {x.get('filename') for x in phone}
    cur_idx = len([x for x in phone if x.get('screen') == 0])
    for num in range(11, 21):
        fname = f'wallpaper_{num}.png'
        if fname not in existing:
            phone.append({
                'isDefault': False,
                'index': cur_idx,
                'screen': 0,
                'type': 12,
                'filename': fname,
                'desc_str_id': 'str_id_graphical_cloud_shape',
                'cmf_info': [''],
                'logging_info': {
                    'custom_dimens': {
                        'Category': 'Graphical',
                        'Graphical image': f'wallpaper_{num}'
                    }
                }
            })
            cur_idx += 1
    with open(f_graph, 'w', encoding='utf-8') as f:
        json.dump(d, f, indent=2)
"

unset -f ENCODE_MP4 COMPRESS_WEBP
