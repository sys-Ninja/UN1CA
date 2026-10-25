.class public Lio/mesalabs/unica/settings/voicechanger/AudioDecoder;
.super Ljava/lang/Object;
.source "AudioDecoder.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static decodeToWav(Landroid/content/Context;Landroid/net/Uri;Ljava/io/File;)Z
    .locals 25

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object/from16 v3, p2

    const/4 v4, 0x0

    const/4 v5, 0x0

    :try_start_0
    new-instance v0, Landroid/media/MediaExtractor;

    invoke-direct {v0}, Landroid/media/MediaExtractor;-><init>()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_6
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    :try_start_1
    invoke-virtual {v0, v1, v2, v4}, Landroid/media/MediaExtractor;->setDataSource(Landroid/content/Context;Landroid/net/Uri;Ljava/util/Map;)V

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->getTrackCount()I

    move-result v6

    const/4 v7, -0x1

    move-object v9, v4

    const/4 v8, 0x0

    :goto_0
    if-ge v8, v6, :cond_1

    invoke-virtual {v0, v8}, Landroid/media/MediaExtractor;->getTrackFormat(I)Landroid/media/MediaFormat;

    move-result-object v10

    const-string v11, "mime"

    invoke-virtual {v10, v11}, Landroid/media/MediaFormat;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    if-eqz v11, :cond_0

    const-string v12, "audio/"

    invoke-virtual {v11, v12}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_0

    move v7, v8

    move-object v9, v10

    goto :goto_1

    :cond_0
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    :cond_1
    :goto_1
    if-ltz v7, :cond_c

    if-nez v9, :cond_2

    goto/16 :goto_7

    :cond_2
    invoke-virtual {v0, v7}, Landroid/media/MediaExtractor;->selectTrack(I)V

    const-string v6, "mime"

    invoke-virtual {v9, v6}, Landroid/media/MediaFormat;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Landroid/media/MediaCodec;->createDecoderByType(Ljava/lang/String;)Landroid/media/MediaCodec;

    move-result-object v6
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_5
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    const/4 v7, 0x0

    :try_start_2
    invoke-virtual {v6, v9, v4, v4, v7}, Landroid/media/MediaCodec;->configure(Landroid/media/MediaFormat;Landroid/view/Surface;Landroid/media/MediaCrypto;I)V

    invoke-virtual {v6}, Landroid/media/MediaCodec;->start()V

    const-string v1, "sample-rate"

    invoke-virtual {v9, v1}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v1

    const-string v8, "channel-count"

    invoke-virtual {v9, v8}, Landroid/media/MediaFormat;->getInteger(Ljava/lang/String;)I

    move-result v8

    new-instance v9, Ljava/io/FileOutputStream;

    invoke-direct {v9, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_4
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    const/16 v10, 0x2c

    :try_start_3
    new-array v10, v10, [B

    invoke-virtual {v9, v10}, Ljava/io/FileOutputStream;->write([B)V

    new-instance v10, Landroid/media/MediaCodec$BufferInfo;

    invoke-direct {v10}, Landroid/media/MediaCodec$BufferInfo;-><init>()V

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    :cond_3
    :goto_2
    if-nez v12, :cond_a

    if-nez v11, :cond_6

    const-wide/16 v14, 0x1388

    invoke-virtual {v6, v14, v15}, Landroid/media/MediaCodec;->dequeueInputBuffer(J)I

    move-result v17

    if-ltz v17, :cond_5

    invoke-virtual/range {v6 .. v17}, Landroid/media/MediaCodec;->getInputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v14

    invoke-virtual {v0, v14, v7}, Landroid/media/MediaExtractor;->readSampleData(Ljava/nio/ByteBuffer;I)I

    move-result v19

    if-gez v19, :cond_4

    const/16 v18, 0x0

    const/16 v19, 0x0

    const-wide/16 v20, 0x0

    const/16 v22, 0x4

    move-object/from16 v16, v6

    invoke-virtual/range {v16 .. v22}, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V

    const/4 v11, 0x1

    goto :goto_3

    :cond_4
    const/16 v18, 0x0

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->getSampleTime()J

    move-result-wide v20

    const/16 v22, 0x0

    move-object/from16 v16, v6

    invoke-virtual/range {v16 .. v22}, Landroid/media/MediaCodec;->queueInputBuffer(IIIJI)V

    invoke-virtual {v0}, Landroid/media/MediaExtractor;->advance()Z

    :cond_5
    :goto_3
    const-wide/16 v14, 0x1388

    goto :goto_4

    :cond_6
    const-wide/16 v14, 0x1388

    :goto_4
    invoke-virtual {v6, v10, v14, v15}, Landroid/media/MediaCodec;->dequeueOutputBuffer(Landroid/media/MediaCodec$BufferInfo;J)I

    move-result v14

    if-ltz v14, :cond_3

    iget v15, v10, Landroid/media/MediaCodec$BufferInfo;->flags:I

    and-int/lit8 v15, v15, 0x4

    if-eqz v15, :cond_7

    const/4 v12, 0x1

    :cond_7
    iget v15, v10, Landroid/media/MediaCodec$BufferInfo;->size:I

    if-lez v15, :cond_9

    invoke-virtual {v6, v14}, Landroid/media/MediaCodec;->getOutputBuffer(I)Ljava/nio/ByteBuffer;

    move-result-object v15

    if-eqz v15, :cond_8

    iget v4, v10, Landroid/media/MediaCodec$BufferInfo;->offset:I

    invoke-virtual {v15, v4}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    iget v4, v10, Landroid/media/MediaCodec$BufferInfo;->offset:I

    iget v7, v10, Landroid/media/MediaCodec$BufferInfo;->size:I

    add-int/2addr v4, v7

    invoke-virtual {v15, v4}, Ljava/nio/ByteBuffer;->limit(I)Ljava/nio/Buffer;

    iget v4, v10, Landroid/media/MediaCodec$BufferInfo;->size:I

    new-array v4, v4, [B

    invoke-virtual {v15, v4}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    invoke-virtual {v9, v4}, Ljava/io/FileOutputStream;->write([B)V

    :cond_8
    iget v4, v10, Landroid/media/MediaCodec$BufferInfo;->size:I

    add-int/2addr v13, v4

    :cond_9
    const/4 v4, 0x0

    invoke-virtual {v6, v14, v4}, Landroid/media/MediaCodec;->releaseOutputBuffer(IZ)V

    const/4 v7, 0x0

    goto :goto_2

    :cond_a
    invoke-virtual {v9}, Ljava/io/FileOutputStream;->flush()V

    invoke-static {v3, v13, v1, v8}, Lio/mesalabs/unica/settings/voicechanger/AudioDecoder;->writeWavHeader(Ljava/io/File;III)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_3

    :try_start_4
    invoke-virtual {v9}, Ljava/io/FileOutputStream;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    :try_start_5
    invoke-virtual {v6}, Landroid/media/MediaCodec;->stop()V

    invoke-virtual {v6}, Landroid/media/MediaCodec;->release()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1

    :catch_1
    :try_start_6
    invoke-virtual {v0}, Landroid/media/MediaExtractor;->release()V
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_2

    :catch_2
    const/4 v0, 0x1

    return v0

    :catch_3
    move-exception v1

    goto :goto_5

    :catchall_0
    move-exception v1

    move-object v9, v4

    goto :goto_8

    :catch_4
    move-exception v1

    move-object v9, v4

    goto :goto_5

    :catchall_1
    move-exception v1

    move-object v6, v4

    move-object v9, v6

    goto :goto_8

    :catch_5
    move-exception v1

    move-object v6, v4

    move-object v9, v6

    goto :goto_5

    :cond_c
    :goto_7
    :try_start_7
    invoke-virtual {v0}, Landroid/media/MediaExtractor;->release()V
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_7

    :catch_7
    return v5

    :catchall_2
    move-exception v1

    move-object v0, v4

    move-object v6, v0

    move-object v9, v6

    goto :goto_8

    :catch_6
    move-exception v1

    move-object v0, v4

    move-object v6, v0

    move-object v9, v6

    :goto_5
    :try_start_8
    const-string v2, "AudioDecoder"

    const-string v3, "decodeToWav failed"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_3

    if-eqz v9, :cond_d

    :try_start_9
    invoke-virtual {v9}, Ljava/io/FileOutputStream;->close()V
    :try_end_9
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_8

    :catch_8
    :cond_d
    if-eqz v6, :cond_e

    :try_start_a
    invoke-virtual {v6}, Landroid/media/MediaCodec;->stop()V

    invoke-virtual {v6}, Landroid/media/MediaCodec;->release()V
    :try_end_a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_a} :catch_9

    :catch_9
    :cond_e
    if-eqz v0, :cond_f

    :try_start_b
    invoke-virtual {v0}, Landroid/media/MediaExtractor;->release()V
    :try_end_b
    .catch Ljava/lang/Exception; {:try_start_b .. :try_end_b} :catch_a

    :catch_a
    :cond_f
    return v5

    :catchall_3
    move-exception v1

    :goto_8
    if-eqz v9, :cond_10

    :try_start_c
    invoke-virtual {v9}, Ljava/io/FileOutputStream;->close()V
    :try_end_c
    .catch Ljava/lang/Exception; {:try_start_c .. :try_end_c} :catch_b

    :catch_b
    :cond_10
    if-eqz v6, :cond_11

    :try_start_d
    invoke-virtual {v6}, Landroid/media/MediaCodec;->stop()V

    invoke-virtual {v6}, Landroid/media/MediaCodec;->release()V
    :try_end_d
    .catch Ljava/lang/Exception; {:try_start_d .. :try_end_d} :catch_c

    :catch_c
    :cond_11
    if-eqz v0, :cond_12

    :try_start_e
    invoke-virtual {v0}, Landroid/media/MediaExtractor;->release()V
    :try_end_e
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_e} :catch_d

    :catch_d
    :cond_12
    throw v1
.end method

.method private static writeWavHeader(Ljava/io/File;III)V
    .locals 7

    :try_start_0
    new-instance v0, Ljava/io/RandomAccessFile;

    const-string v1, "rw"

    invoke-direct {v0, p0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    const-wide/16 v1, 0x0

    :try_start_1
    invoke-virtual {v0, v1, v2}, Ljava/io/RandomAccessFile;->seek(J)V

    add-int/lit8 v1, p1, 0x24

    mul-int v2, p2, p3

    mul-int/lit8 v2, v2, 0x2

    const/16 v3, 0x2c

    new-array v3, v3, [B

    const/4 v4, 0x0

    const/16 v5, 0x52

    aput-byte v5, v3, v4

    const/4 v4, 0x1

    const/16 v5, 0x49

    aput-byte v5, v3, v4

    const/4 v4, 0x2

    const/16 v5, 0x46

    aput-byte v5, v3, v4

    const/4 v4, 0x3

    const/16 v5, 0x46

    aput-byte v5, v3, v4

    and-int/lit16 v4, v1, 0xff

    int-to-byte v4, v4

    const/4 v5, 0x4

    aput-byte v4, v3, v5

    shr-int/lit8 v4, v1, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    const/4 v5, 0x5

    aput-byte v4, v3, v5

    shr-int/lit8 v4, v1, 0x10

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    const/4 v5, 0x6

    aput-byte v4, v3, v5

    const/4 v4, 0x7

    shr-int/lit8 v1, v1, 0x18

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, v3, v4

    const/16 v1, 0x8

    const/16 v4, 0x57

    aput-byte v4, v3, v1

    const/16 v1, 0x9

    const/16 v4, 0x41

    aput-byte v4, v3, v1

    const/16 v1, 0xa

    const/16 v4, 0x56

    aput-byte v4, v3, v1

    const/16 v1, 0xb

    const/16 v4, 0x45

    aput-byte v4, v3, v1

    const/16 v1, 0xc

    const/16 v4, 0x66

    aput-byte v4, v3, v1

    const/16 v1, 0xd

    const/16 v4, 0x6d

    aput-byte v4, v3, v1

    const/16 v1, 0xe

    const/16 v4, 0x74

    aput-byte v4, v3, v1

    const/16 v1, 0xf

    const/16 v4, 0x20

    aput-byte v4, v3, v1

    const/16 v1, 0x10

    const/16 v6, 0x10

    aput-byte v6, v3, v1

    const/16 v1, 0x14

    const/4 v6, 0x1

    aput-byte v6, v3, v1

    const/16 v1, 0x16

    int-to-byte p3, p3

    aput-byte p3, v3, v1

    const/16 v1, 0x18

    and-int/lit16 v6, p2, 0xff

    int-to-byte v6, v6

    aput-byte v6, v3, v1

    const/16 v1, 0x19

    shr-int/lit8 v6, p2, 0x8

    and-int/lit16 v6, v6, 0xff

    int-to-byte v6, v6

    aput-byte v6, v3, v1

    const/16 v1, 0x1a

    shr-int/lit8 v6, p2, 0x10

    and-int/lit16 v6, v6, 0xff

    int-to-byte v6, v6

    aput-byte v6, v3, v1

    const/16 v1, 0x1b

    shr-int/lit8 p2, p2, 0x18

    and-int/lit16 p2, p2, 0xff

    int-to-byte p2, p2

    aput-byte p2, v3, v1

    const/16 p2, 0x1c

    and-int/lit16 v1, v2, 0xff

    int-to-byte v1, v1

    aput-byte v1, v3, p2

    const/16 p2, 0x1d

    shr-int/lit8 v1, v2, 0x8

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, v3, p2

    const/16 p2, 0x1e

    shr-int/lit8 v1, v2, 0x10

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, v3, p2

    const/16 p2, 0x1f

    shr-int/lit8 v1, v2, 0x18

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, v3, p2

    const/16 p2, 0x20

    mul-int/lit8 p3, p3, 0x2

    int-to-byte p3, p3

    aput-byte p3, v3, p2

    const/16 p2, 0x22

    const/16 p3, 0x10

    aput-byte p3, v3, p2

    const/16 p2, 0x24

    const/16 p3, 0x64

    aput-byte p3, v3, p2

    const/16 p2, 0x25

    const/16 p3, 0x61

    aput-byte p3, v3, p2

    const/16 p2, 0x26

    aput-byte v4, v3, p2

    const/16 p2, 0x27

    const/16 p3, 0x61

    aput-byte p3, v3, p2

    const/16 p2, 0x28

    and-int/lit16 p3, p1, 0xff

    int-to-byte p3, p3

    aput-byte p3, v3, p2

    const/16 p2, 0x29

    shr-int/lit8 p3, p1, 0x8

    and-int/lit16 p3, p3, 0xff

    int-to-byte p3, p3

    aput-byte p3, v3, p2

    const/16 p2, 0x2a

    shr-int/lit8 p3, p1, 0x10

    and-int/lit16 p3, p3, 0xff

    int-to-byte p3, p3

    aput-byte p3, v3, p2

    const/16 p2, 0x2b

    shr-int/lit8 p1, p1, 0x18

    and-int/lit16 p1, p1, 0xff

    int-to-byte p1, p1

    aput-byte p1, v3, p2

    invoke-virtual {v0, v3}, Ljava/io/RandomAccessFile;->write([B)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_0

    :catchall_0
    move-exception p1

    :try_start_3
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    :catchall_1
    :try_start_4
    throw p1
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1

    :catch_1
    :goto_0
    return-void
.end method
