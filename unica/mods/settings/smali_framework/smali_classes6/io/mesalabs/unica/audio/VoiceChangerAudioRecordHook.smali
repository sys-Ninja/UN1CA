.class public Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;
.super Ljava/lang/Object;
.source "VoiceChangerAudioRecordHook.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;
    }
.end annotation


# static fields
.field private static final PROP_ENABLED:Ljava/lang/String; = "persist.sys.unica.vc.enabled"

.field private static final PROP_GLOBAL:Ljava/lang/String; = "persist.sys.unica.vc.global"

.field private static final PROP_PRESET:Ljava/lang/String; = "persist.sys.unica.vc.preset"

.field private static final PROP_SEMI:Ljava/lang/String; = "persist.sys.unica.vc.semitones"

.field private static final sSessions:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/media/AudioRecord;",
            "Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 233
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->sSessions:Ljava/util/Map;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static isGlobalActive()Z
    .locals 2

    .line 236
    const-string v0, "persist.sys.unica.vc.enabled"

    const/4 v1, 0x0

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 237
    const-string v0, "persist.sys.unica.vc.global"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    nop

    .line 236
    :goto_0
    return v1
.end method

.method public static onAudioRecordRead(Landroid/media/AudioRecord;Ljava/nio/ByteBuffer;I)V
    .locals 3

    .line 286
    if-eqz p0, :cond_3

    if-eqz p1, :cond_3

    const/4 v0, 0x2

    if-ge p2, v0, :cond_0

    goto :goto_2

    .line 287
    :cond_0
    invoke-static {}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->isGlobalActive()Z

    move-result v1

    if-nez v1, :cond_1

    return-void

    .line 290
    :cond_1
    :try_start_0
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->hasArray()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 291
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object v0

    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->arrayOffset()I

    move-result v1

    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->position()I

    move-result p1

    add-int/2addr v1, p1

    invoke-static {p0, v0, v1, p2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[BII)V

    goto :goto_0

    .line 293
    :cond_2
    div-int/2addr p2, v0

    .line 294
    new-array v0, p2, [S

    .line 295
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->position()I

    move-result v1

    .line 296
    sget-object v2, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    .line 297
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->asShortBuffer()Ljava/nio/ShortBuffer;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/nio/ShortBuffer;->get([S)Ljava/nio/ShortBuffer;

    .line 299
    const/4 v2, 0x0

    invoke-static {p0, v0, v2, p2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[SII)V

    .line 301
    invoke-virtual {p1, v1}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    move-result-object p0

    check-cast p0, Ljava/nio/ByteBuffer;

    .line 302
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->asShortBuffer()Ljava/nio/ShortBuffer;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/nio/ShortBuffer;->put([S)Ljava/nio/ShortBuffer;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 305
    :goto_0
    goto :goto_1

    .line 304
    :catchall_0
    move-exception p0

    .line 306
    :goto_1
    return-void

    .line 286
    :cond_3
    :goto_2
    return-void
.end method

.method public static onAudioRecordRead(Landroid/media/AudioRecord;[BII)V
    .locals 5

    .line 263
    if-eqz p0, :cond_4

    if-eqz p1, :cond_4

    const/4 v0, 0x2

    if-ge p3, v0, :cond_0

    goto :goto_3

    .line 264
    :cond_0
    invoke-static {}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->isGlobalActive()Z

    move-result v1

    if-nez v1, :cond_1

    return-void

    .line 267
    :cond_1
    :try_start_0
    div-int/2addr p3, v0

    .line 268
    new-array v0, p3, [S

    .line 269
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, p3, :cond_2

    .line 270
    mul-int/lit8 v3, v2, 0x2

    add-int/2addr v3, p2

    .line 271
    aget-byte v4, p1, v3

    and-int/lit16 v4, v4, 0xff

    add-int/lit8 v3, v3, 0x1

    aget-byte v3, p1, v3

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v3, v4

    int-to-short v3, v3

    aput-short v3, v0, v2

    .line 269
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 274
    :cond_2
    invoke-static {p0, v0, v1, p3}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->onAudioRecordRead(Landroid/media/AudioRecord;[SII)V

    .line 276
    nop

    :goto_1
    if-ge v1, p3, :cond_3

    .line 277
    mul-int/lit8 p0, v1, 0x2

    add-int/2addr p0, p2

    .line 278
    aget-short v2, v0, v1

    and-int/lit16 v2, v2, 0xff

    int-to-byte v2, v2

    aput-byte v2, p1, p0

    .line 279
    add-int/lit8 p0, p0, 0x1

    aget-short v2, v0, v1

    shr-int/lit8 v2, v2, 0x8

    and-int/lit16 v2, v2, 0xff

    int-to-byte v2, v2

    aput-byte v2, p1, p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 276
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 282
    :cond_3
    goto :goto_2

    .line 281
    :catchall_0
    move-exception p0

    .line 283
    :goto_2
    return-void

    .line 263
    :cond_4
    :goto_3
    return-void
.end method

.method public static onAudioRecordRead(Landroid/media/AudioRecord;[SII)V
    .locals 4

    .line 241
    if-eqz p0, :cond_5

    if-eqz p1, :cond_5

    if-gtz p3, :cond_0

    goto :goto_1

    .line 242
    :cond_0
    invoke-static {}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->isGlobalActive()Z

    move-result v0

    if-nez v0, :cond_1

    return-void

    .line 246
    :cond_1
    :try_start_0
    sget-object v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->sSessions:Ljava/util/Map;

    monitor-enter v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 247
    :try_start_1
    sget-object v1, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->sSessions:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;

    .line 248
    if-nez v1, :cond_4

    .line 249
    invoke-virtual {p0}, Landroid/media/AudioRecord;->getSampleRate()I

    move-result v1

    .line 250
    if-gtz v1, :cond_2

    const v1, 0xbb80

    .line 251
    :cond_2
    invoke-virtual {p0}, Landroid/media/AudioRecord;->getChannelCount()I

    move-result v2

    .line 252
    if-gtz v2, :cond_3

    const/4 v2, 0x1

    .line 253
    :cond_3
    new-instance v3, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;

    invoke-direct {v3, v1, v2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;-><init>(II)V

    .line 254
    sget-object v1, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;->sSessions:Ljava/util/Map;

    invoke-interface {v1, p0, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-object v1, v3

    .line 256
    :cond_4
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 257
    :try_start_2
    invoke-virtual {v1, p1, p2, p3}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->processShorts([SII)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 259
    goto :goto_0

    .line 256
    :catchall_0
    move-exception p0

    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 258
    :catchall_1
    move-exception p0

    .line 260
    :goto_0
    return-void

    .line 241
    :cond_5
    :goto_1
    return-void
.end method
