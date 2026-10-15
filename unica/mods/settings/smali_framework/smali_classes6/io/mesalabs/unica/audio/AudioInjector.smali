.class public Lio/mesalabs/unica/audio/AudioInjector;
.super Ljava/lang/Object;
.source "AudioInjector.java"


# instance fields
.field private byteBuf:[B

.field private injectFinished:Z

.field private injectStream:Ljava/io/InputStream;

.field private injectTrack:Landroid/media/AudioTrack;

.field private sampleRate:I


# direct methods
.method public constructor <init>(I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-lez p1, :cond_0

    goto :goto_0

    :cond_0
    const p1, 0xbb80

    :goto_0
    iput p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->sampleRate:I

    return-void
.end method

.method private finishInjection([SII)V
    .locals 3

    const/4 v0, 0x0

    :goto_0
    if-ge v0, p3, :cond_0

    add-int v1, p2, v0

    const/4 v2, 0x0

    aput-short v2, p1, v1

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    :try_start_0
    iget-object p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Ljava/io/InputStream;->close()V

    const/4 p1, 0x0

    iput-object p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    :try_start_1
    iget-object p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectTrack:Landroid/media/AudioTrack;

    if-eqz p1, :cond_2

    invoke-virtual {p1}, Landroid/media/AudioTrack;->stop()V

    iget-object p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectTrack:Landroid/media/AudioTrack;

    invoke-virtual {p1}, Landroid/media/AudioTrack;->release()V

    const/4 p1, 0x0

    iput-object p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectTrack:Landroid/media/AudioTrack;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    :cond_2
    const/4 p1, 0x1

    iput-boolean p1, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectFinished:Z

    :try_start_2
    const-string p0, "persist.sys.unica.vc.inject"

    const-string p1, "false"

    invoke-static {p0, p1}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    :catch_2
    return-void
.end method


# virtual methods
.method public inject([SII)V
    .locals 12

    iget-boolean v0, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectFinished:Z

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_2

    iget-object v0, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    if-nez v0, :cond_2

    :try_start_0
    new-instance v0, Ljava/io/File;

    const-string v3, "/sdcard/Recordings/unica_inject.wav"

    invoke-direct {v0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v3

    if-nez v3, :cond_0

    new-instance v0, Ljava/io/File;

    const-string v3, "/sdcard/Download/unica_inject.wav"

    invoke-direct {v0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    :cond_0
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v3

    if-eqz v3, :cond_1

    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    iput-object v3, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v3

    const-wide/16 v5, 0x2c

    cmp-long v0, v3, v5

    if-lez v0, :cond_1

    iget-object v0, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    invoke-virtual {v0, v5, v6}, Ljava/io/InputStream;->skip(J)J

    iget v5, p0, Lio/mesalabs/unica/audio/AudioInjector;->sampleRate:I

    const/4 v0, 0x4

    const/4 v3, 0x2

    invoke-static {v5, v0, v3}, Landroid/media/AudioTrack;->getMinBufferSize(III)I

    move-result v0

    mul-int/lit8 v8, v0, 0x2

    new-instance v0, Landroid/media/AudioTrack;

    const/4 v4, 0x3

    const/4 v6, 0x4

    const/4 v7, 0x2

    const/4 v9, 0x1

    move-object v3, v0

    invoke-direct/range {v3 .. v9}, Landroid/media/AudioTrack;-><init>(IIIIII)V

    iput-object v0, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectTrack:Landroid/media/AudioTrack;

    invoke-virtual {v0}, Landroid/media/AudioTrack;->play()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    :cond_1
    iput-boolean v2, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectFinished:Z

    :try_start_1
    const-string v0, "persist.sys.unica.vc.inject"

    const-string v3, "false"

    invoke-static {v0, v3}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    :cond_2
    :goto_0
    iget-object v0, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    if-eqz v0, :cond_6

    mul-int/lit8 v0, p3, 0x2

    :try_start_2
    iget-object v3, p0, Lio/mesalabs/unica/audio/AudioInjector;->byteBuf:[B

    if-eqz v3, :cond_3

    array-length v3, v3

    if-ge v3, v0, :cond_4

    :cond_3
    new-array v3, v0, [B

    iput-object v3, p0, Lio/mesalabs/unica/audio/AudioInjector;->byteBuf:[B

    :cond_4
    iget-object v3, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectStream:Ljava/io/InputStream;

    iget-object v4, p0, Lio/mesalabs/unica/audio/AudioInjector;->byteBuf:[B

    invoke-virtual {v3, v4, v1, v0}, Ljava/io/InputStream;->read([BII)I

    move-result v0

    if-lez v0, :cond_7

    div-int/lit8 v0, v0, 0x2

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v0, :cond_5

    iget-object v4, p0, Lio/mesalabs/unica/audio/AudioInjector;->byteBuf:[B

    mul-int/lit8 v5, v3, 0x2

    aget-byte v6, v4, v5

    and-int/lit16 v6, v6, 0xff

    add-int/2addr v5, v2

    aget-byte v4, v4, v5

    shl-int/lit8 v4, v4, 0x8

    or-int/2addr v4, v6

    int-to-short v4, v4

    add-int v5, p2, v3

    aput-short v4, p1, v5

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_5
    iget-object v2, p0, Lio/mesalabs/unica/audio/AudioInjector;->injectTrack:Landroid/media/AudioTrack;

    if-eqz v2, :cond_8

    invoke-virtual {v2, p1, p2, v0}, Landroid/media/AudioTrack;->write([SII)I

    :goto_2
    if-ge v0, p3, :cond_8

    add-int v2, p2, v0

    aput-short v1, p1, v2
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :catch_2
    :cond_6
    invoke-direct {p0, p1, p2, p3}, Lio/mesalabs/unica/audio/AudioInjector;->finishInjection([SII)V

    goto :goto_3

    :cond_7
    invoke-direct {p0, p1, p2, p3}, Lio/mesalabs/unica/audio/AudioInjector;->finishInjection([SII)V

    :cond_8
    :goto_3
    return-void
.end method
