.class public Lio/mesalabs/unica/audio/Sonic;
.super Ljava/lang/Object;
.source "Sonic.java"


# static fields
.field static final synthetic $assertionsDisabled:Z = false

.field private static final SINC_FILTER_POINTS:I = 0xc

.field private static final SINC_TABLE_SIZE:I = 0x259

.field private static final SONIC_AMDF_FREQ:I = 0xfa0

.field private static final SONIC_MAX_PITCH:I = 0x190

.field private static final SONIC_MIN_PITCH:I = 0x41

.field private static final sincTable:[S


# instance fields
.field private downSampleBuffer:[S

.field private inputBuffer:[S

.field private inputBufferSize:I

.field private maxDiff:I

.field private maxPeriod:I

.field private maxRequired:I

.field private minDiff:I

.field private minPeriod:I

.field private newRatePosition:I

.field private numChannels:I

.field private numInputSamples:I

.field private numOutputSamples:I

.field private numPitchSamples:I

.field private oldRatePosition:I

.field private outputBuffer:[S

.field private outputBufferSize:I

.field private pitch:F

.field private pitchBuffer:[S

.field private pitchBufferSize:I

.field private prevMinDiff:I

.field private prevPeriod:I

.field private quality:I

.field private rate:F

.field private remainingInputToCopy:I

.field private sampleRate:I

.field private speed:F

.field private useChordPitch:Z

.field private volume:F


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 11
    nop

    .line 23
    const/16 v0, 0x259

    new-array v0, v0, [S

    fill-array-data v0, :array_0

    sput-object v0, Lio/mesalabs/unica/audio/Sonic;->sincTable:[S

    return-void

    nop

    :array_0
    .array-data 2
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
        -0x1s
        -0x1s
        -0x2s
        -0x2s
        -0x3s
        -0x4s
        -0x6s
        -0x7s
        -0x9s
        -0xas
        -0xcs
        -0xes
        -0x11s
        -0x13s
        -0x15s
        -0x18s
        -0x1as
        -0x1ds
        -0x20s
        -0x22s
        -0x25s
        -0x28s
        -0x2as
        -0x2cs
        -0x2fs
        -0x30s
        -0x32s
        -0x33s
        -0x34s
        -0x35s
        -0x35s
        -0x35s
        -0x34s
        -0x32s
        -0x30s
        -0x2es
        -0x2bs
        -0x27s
        -0x22s
        -0x1ds
        -0x16s
        -0x10s
        -0x8s
        0x0s
        0x9s
        0x13s
        0x1ds
        0x29s
        0x35s
        0x41s
        0x4fs
        0x5cs
        0x6bs
        0x79s
        0x89s
        0x98s
        0xa8s
        0xb8s
        0xc8s
        0xd7s
        0xe7s
        0xf7s
        0x106s
        0x114s
        0x123s
        0x130s
        0x13ds
        0x148s
        0x153s
        0x15cs
        0x165s
        0x16bs
        0x171s
        0x174s
        0x176s
        0x177s
        0x175s
        0x171s
        0x16bs
        0x163s
        0x159s
        0x14cs
        0x13es
        0x12cs
        0x119s
        0x103s
        0xeas
        0xd0s
        0xb2s
        0x93s
        0x71s
        0x4ds
        0x27s
        0x0s
        -0x29s
        -0x55s
        -0x82s
        -0xb1s
        -0xe1s
        -0x112s
        -0x144s
        -0x177s
        -0x1aas
        -0x1des
        -0x212s
        -0x245s
        -0x278s
        -0x2aas
        -0x2dbs
        -0x30bs
        -0x339s
        -0x366s
        -0x390s
        -0x3b7s
        -0x3dds
        -0x3ffs
        -0x41ds
        -0x438s
        -0x450s
        -0x463s
        -0x472s
        -0x47ds
        -0x482s
        -0x483s
        -0x47fs
        -0x475s
        -0x465s
        -0x451s
        -0x436s
        -0x416s
        -0x3efs
        -0x3c3s
        -0x391s
        -0x359s
        -0x31cs
        -0x2d8s
        -0x28fs
        -0x240s
        -0x1ecs
        -0x193s
        -0x135s
        -0xd2s
        -0x6bs
        0x0s
        0x6fs
        0xe1s
        0x156s
        0x1ces
        0x248s
        0x2c4s
        0x341s
        0x3bes
        0x43cs
        0x4b9s
        0x535s
        0x5afs
        0x627s
        0x69ds
        0x70fs
        0x77cs
        0x7e6s
        0x84as
        0x8a8s
        0x900s
        0x950s
        0x999s
        0x9das
        0xa13s
        0xa41s
        0xa67s
        0xa81s
        0xa92s
        0xa97s
        0xa91s
        0xa7fs
        0xa61s
        0xa36s
        0x9ffs
        0x9bbs
        0x96bs
        0x90ds
        0x8a3s
        0x82cs
        0x7a8s
        0x717s
        0x67as
        0x5d1s
        0x51cs
        0x45bs
        0x390s
        0x2bas
        0x1das
        0xf1s
        0x0s
        -0xf9s
        -0x1fas
        -0x301s
        -0x40ds
        -0x51es
        -0x632s
        -0x748s
        -0x860s
        -0x978s
        -0xa8fs
        -0xba4s
        -0xcb6s
        -0xdc3s
        -0xecbs
        -0xfcbs
        -0x10c3s
        -0x11b1s
        -0x1295s
        -0x136cs
        -0x1436s
        -0x14f0s
        -0x159bs
        -0x1635s
        -0x16bbs
        -0x172fs
        -0x178ds
        -0x17d5s
        -0x1806s
        -0x181fs
        -0x181fs
        -0x1805s
        -0x17d0s
        -0x177fs
        -0x1711s
        -0x1687s
        -0x15dfs
        -0x1519s
        -0x1434s
        -0x1330s
        -0x120ds
        -0x10cas
        -0xf68s
        -0xde6s
        -0xc45s
        -0xa85s
        -0x8a6s
        -0x6a9s
        -0x48es
        -0x255s
        0x0s
        0x271s
        0x4fds
        0x7a3s
        0xa62s
        0xd3as
        0x1027s
        0x132as
        0x1641s
        0x196as
        0x1ca4s
        0x1feds
        0x2343s
        0x26a5s
        0x2a11s
        0x2d86s
        0x3100s
        0x347fs
        0x37ffs
        0x3b80s
        0x3f00s
        0x427bs
        0x45f0s
        0x495es
        0x4cc1s
        0x5018s
        0x5361s
        0x569as
        0x59c1s
        0x5cd3s
        0x5fcfs
        0x62b4s
        0x657es
        0x682ds
        0x6abfs
        0x6d31s
        0x6f83s
        0x71b3s
        0x73c0s
        0x75a7s
        0x7769s
        0x7903s
        0x7a75s
        0x7bbes
        0x7cdcs
        0x7dd0s
        0x7e98s
        0x7f35s
        0x7fa5s
        0x7fe8s
        0x7fffs
        0x7fe8s
        0x7fa5s
        0x7f35s
        0x7e98s
        0x7dd0s
        0x7cdcs
        0x7bbes
        0x7a75s
        0x7903s
        0x7769s
        0x75a7s
        0x73c0s
        0x71b3s
        0x6f83s
        0x6d31s
        0x6abfs
        0x682ds
        0x657es
        0x62b4s
        0x5fcfs
        0x5cd3s
        0x59c1s
        0x569as
        0x5361s
        0x5018s
        0x4cc1s
        0x495es
        0x45f0s
        0x427bs
        0x3f00s
        0x3b80s
        0x37ffs
        0x347fs
        0x3100s
        0x2d86s
        0x2a11s
        0x26a5s
        0x2343s
        0x1feds
        0x1ca4s
        0x196as
        0x1641s
        0x132as
        0x1027s
        0xd3as
        0xa62s
        0x7a3s
        0x4fds
        0x271s
        0x0s
        -0x255s
        -0x48es
        -0x6a9s
        -0x8a6s
        -0xa85s
        -0xc45s
        -0xde6s
        -0xf68s
        -0x10cas
        -0x120ds
        -0x1330s
        -0x1434s
        -0x1519s
        -0x15dfs
        -0x1687s
        -0x1711s
        -0x177fs
        -0x17d0s
        -0x1805s
        -0x181fs
        -0x181fs
        -0x1806s
        -0x17d5s
        -0x178ds
        -0x172fs
        -0x16bbs
        -0x1635s
        -0x159bs
        -0x14f0s
        -0x1436s
        -0x136cs
        -0x1295s
        -0x11b1s
        -0x10c3s
        -0xfcbs
        -0xecbs
        -0xdc3s
        -0xcb6s
        -0xba4s
        -0xa8fs
        -0x978s
        -0x860s
        -0x748s
        -0x632s
        -0x51es
        -0x40ds
        -0x301s
        -0x1fas
        -0xf9s
        0x0s
        0xf1s
        0x1das
        0x2bas
        0x390s
        0x45bs
        0x51cs
        0x5d1s
        0x67as
        0x717s
        0x7a8s
        0x82cs
        0x8a3s
        0x90ds
        0x96bs
        0x9bbs
        0x9ffs
        0xa36s
        0xa61s
        0xa7fs
        0xa91s
        0xa97s
        0xa92s
        0xa81s
        0xa67s
        0xa41s
        0xa13s
        0x9das
        0x999s
        0x950s
        0x900s
        0x8a8s
        0x84as
        0x7e6s
        0x77cs
        0x70fs
        0x69ds
        0x627s
        0x5afs
        0x535s
        0x4b9s
        0x43cs
        0x3bes
        0x341s
        0x2c4s
        0x248s
        0x1ces
        0x156s
        0xe1s
        0x6fs
        0x0s
        -0x6bs
        -0xd2s
        -0x135s
        -0x193s
        -0x1ecs
        -0x240s
        -0x28fs
        -0x2d8s
        -0x31cs
        -0x359s
        -0x391s
        -0x3c3s
        -0x3efs
        -0x416s
        -0x436s
        -0x451s
        -0x465s
        -0x475s
        -0x47fs
        -0x483s
        -0x482s
        -0x47ds
        -0x472s
        -0x463s
        -0x450s
        -0x438s
        -0x41ds
        -0x3ffs
        -0x3dds
        -0x3b7s
        -0x390s
        -0x366s
        -0x339s
        -0x30bs
        -0x2dbs
        -0x2aas
        -0x278s
        -0x245s
        -0x212s
        -0x1des
        -0x1aas
        -0x177s
        -0x144s
        -0x112s
        -0xe1s
        -0xb1s
        -0x82s
        -0x55s
        -0x29s
        0x0s
        0x27s
        0x4ds
        0x71s
        0x93s
        0xb2s
        0xd0s
        0xeas
        0x103s
        0x119s
        0x12cs
        0x13es
        0x14cs
        0x159s
        0x163s
        0x16bs
        0x171s
        0x175s
        0x177s
        0x176s
        0x174s
        0x171s
        0x16bs
        0x165s
        0x15cs
        0x153s
        0x148s
        0x13ds
        0x130s
        0x123s
        0x114s
        0x106s
        0xf7s
        0xe7s
        0xd7s
        0xc8s
        0xb8s
        0xa8s
        0x98s
        0x89s
        0x79s
        0x6bs
        0x5cs
        0x4fs
        0x41s
        0x35s
        0x29s
        0x1ds
        0x13s
        0x9s
        0x0s
        -0x8s
        -0x10s
        -0x16s
        -0x1ds
        -0x22s
        -0x27s
        -0x2bs
        -0x2es
        -0x30s
        -0x32s
        -0x34s
        -0x35s
        -0x35s
        -0x35s
        -0x34s
        -0x33s
        -0x32s
        -0x30s
        -0x2fs
        -0x2cs
        -0x2as
        -0x28s
        -0x25s
        -0x22s
        -0x20s
        -0x1ds
        -0x1as
        -0x18s
        -0x15s
        -0x13s
        -0x11s
        -0xes
        -0xcs
        -0xas
        -0x9s
        -0x7s
        -0x6s
        -0x4s
        -0x3s
        -0x2s
        -0x2s
        -0x1s
        -0x1s
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
        0x0s
    .end array-data
.end method

.method public constructor <init>(II)V
    .locals 0

    .line 257
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 258
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->allocateStreamBuffers(II)V

    .line 259
    const/high16 p1, 0x3f800000    # 1.0f

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->speed:F

    .line 260
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    .line 261
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->volume:F

    .line 262
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->rate:F

    .line 263
    const/4 p1, 0x0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    .line 264
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    .line 265
    iput-boolean p1, p0, Lio/mesalabs/unica/audio/Sonic;->useChordPitch:Z

    .line 266
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->quality:I

    .line 267
    return-void
.end method

.method private addBytesToInputBuffer([BI)V
    .locals 6

    .line 365
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int/lit8 v0, v0, 0x2

    div-int v0, p2, v0

    .line 368
    invoke-direct {p0, v0}, Lio/mesalabs/unica/audio/Sonic;->enlargeInputBufferIfNeeded(I)V

    .line 369
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v1, v1, v2

    .line 370
    const/4 v2, 0x0

    :goto_0
    add-int/lit8 v3, v2, 0x1

    if-ge v3, p2, :cond_0

    .line 371
    aget-byte v4, p1, v2

    and-int/lit16 v4, v4, 0xff

    aget-byte v3, p1, v3

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v3, v4

    int-to-short v3, v3

    .line 372
    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    add-int/lit8 v5, v1, 0x1

    aput-short v3, v4, v1

    .line 370
    add-int/lit8 v2, v2, 0x2

    move v1, v5

    goto :goto_0

    .line 374
    :cond_0
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    add-int/2addr p1, v0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 375
    return-void
.end method

.method private addFloatSamplesToInputBuffer([FI)V
    .locals 6

    .line 320
    if-nez p2, :cond_0

    .line 321
    return-void

    .line 323
    :cond_0
    invoke-direct {p0, p2}, Lio/mesalabs/unica/audio/Sonic;->enlargeInputBufferIfNeeded(I)V

    .line 324
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v0, v0, v1

    .line 325
    const/4 v1, 0x0

    :goto_0
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v2, v2, p2

    if-ge v1, v2, :cond_1

    .line 326
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    add-int/lit8 v3, v0, 0x1

    aget v4, p1, v1

    const v5, 0x46fffe00    # 32767.0f

    mul-float v4, v4, v5

    float-to-int v4, v4

    int-to-short v4, v4

    aput-short v4, v2, v0

    .line 325
    add-int/lit8 v1, v1, 0x1

    move v0, v3

    goto :goto_0

    .line 328
    :cond_1
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    add-int/2addr p1, p2

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 329
    return-void
.end method

.method private addShortSamplesToInputBuffer([SI)V
    .locals 6

    .line 336
    if-nez p2, :cond_0

    .line 337
    return-void

    .line 339
    :cond_0
    invoke-direct {p0, p2}, Lio/mesalabs/unica/audio/Sonic;->enlargeInputBufferIfNeeded(I)V

    .line 340
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    const/4 v4, 0x0

    move-object v0, p0

    move-object v3, p1

    move v5, p2

    invoke-direct/range {v0 .. v5}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 341
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    add-int/2addr p1, p2

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 342
    return-void
.end method

.method private addUnsignedByteSamplesToInputBuffer([BI)V
    .locals 5

    .line 351
    invoke-direct {p0, p2}, Lio/mesalabs/unica/audio/Sonic;->enlargeInputBufferIfNeeded(I)V

    .line 352
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v0, v0, v1

    .line 353
    const/4 v1, 0x0

    :goto_0
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v2, v2, p2

    if-ge v1, v2, :cond_0

    .line 354
    aget-byte v2, p1, v1

    and-int/lit16 v2, v2, 0xff

    add-int/lit8 v2, v2, -0x80

    int-to-short v2, v2

    .line 355
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    add-int/lit8 v4, v0, 0x1

    shl-int/lit8 v2, v2, 0x8

    int-to-short v2, v2

    aput-short v2, v3, v0

    .line 353
    add-int/lit8 v1, v1, 0x1

    move v0, v4

    goto :goto_0

    .line 357
    :cond_0
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    add-int/2addr p1, p2

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 358
    return-void
.end method

.method private adjustPitch(I)V
    .locals 13

    .line 769
    nop

    .line 771
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    if-ne v0, p1, :cond_0

    .line 772
    return-void

    .line 774
    :cond_0
    invoke-direct {p0, p1}, Lio/mesalabs/unica/audio/Sonic;->moveNewSamplesToPitchBuffer(I)V

    const/4 p1, 0x0

    const/4 v10, 0x0

    .line 775
    :goto_0
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    sub-int/2addr v0, v10

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    if-lt v0, v1, :cond_2

    .line 776
    iget-object v0, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    invoke-direct {p0, v0, v10, p1}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriod([SIZ)I

    move-result v11

    .line 777
    int-to-float v0, v11

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    div-float/2addr v0, v1

    float-to-int v12, v0

    .line 778
    invoke-direct {p0, v12}, Lio/mesalabs/unica/audio/Sonic;->enlargeOutputBufferIfNeeded(I)V

    .line 779
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v0, v0, v1

    if-ltz v0, :cond_1

    .line 780
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget-object v7, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    add-int v0, v10, v11

    sub-int v8, v0, v12

    move-object v0, p0

    move v1, v12

    move v6, v10

    invoke-direct/range {v0 .. v8}, Lio/mesalabs/unica/audio/Sonic;->overlapAdd(II[SI[SI[SI)V

    goto :goto_1

    .line 783
    :cond_1
    sub-int v3, v12, v11

    .line 784
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v5, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    iget-object v6, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget-object v8, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    move-object v0, p0

    move v1, v11

    move v7, v10

    move v9, v10

    invoke-direct/range {v0 .. v9}, Lio/mesalabs/unica/audio/Sonic;->overlapAddWithSeparation(III[SI[SI[SI)V

    .line 787
    :goto_1
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr v0, v12

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 788
    add-int/2addr v10, v11

    goto :goto_0

    .line 790
    :cond_2
    invoke-direct {p0, v10}, Lio/mesalabs/unica/audio/Sonic;->removePitchSamples(I)V

    .line 791
    return-void
.end method

.method private adjustRate(FI)V
    .locals 8

    .line 854
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    int-to-float v0, v0

    div-float/2addr v0, p1

    float-to-int p1, v0

    .line 855
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    .line 857
    nop

    .line 860
    :goto_0
    const/16 v1, 0x4000

    if-gt p1, v1, :cond_7

    if-le v0, v1, :cond_0

    goto :goto_4

    .line 864
    :cond_0
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    if-ne v1, p2, :cond_1

    .line 865
    return-void

    .line 867
    :cond_1
    invoke-direct {p0, p2}, Lio/mesalabs/unica/audio/Sonic;->moveNewSamplesToPitchBuffer(I)V

    .line 869
    const/4 p2, 0x0

    const/4 v1, 0x0

    :goto_1
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    add-int/lit8 v2, v2, -0xc

    if-ge v1, v2, :cond_6

    .line 870
    :goto_2
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    const/4 v3, 0x1

    add-int/2addr v2, v3

    mul-int v2, v2, p1

    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    mul-int v4, v4, v0

    if-le v2, v4, :cond_3

    .line 871
    invoke-direct {p0, v3}, Lio/mesalabs/unica/audio/Sonic;->enlargeOutputBufferIfNeeded(I)V

    .line 872
    const/4 v2, 0x0

    :goto_3
    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    if-ge v2, v4, :cond_2

    .line 873
    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v5, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    iget v6, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v5, v5, v6

    add-int/2addr v5, v2

    iget-object v6, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget v7, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v7, v7, v1

    add-int/2addr v7, v2

    invoke-direct {p0, v6, v7, v0, p1}, Lio/mesalabs/unica/audio/Sonic;->interpolate([SIII)S

    move-result v6

    aput-short v6, v4, v5

    .line 872
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 876
    :cond_2
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    add-int/2addr v2, v3

    iput v2, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    .line 877
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr v2, v3

    iput v2, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    goto :goto_2

    .line 879
    :cond_3
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    add-int/2addr v2, v3

    iput v2, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    .line 880
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    if-ne v2, v0, :cond_5

    .line 881
    iput p2, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    .line 882
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    if-eq v2, p1, :cond_4

    .line 883
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v3, "Assertion failed: newRatePosition != newSampleRate\n"

    new-array v4, p2, [Ljava/lang/Object;

    invoke-virtual {v2, v3, v4}, Ljava/io/PrintStream;->printf(Ljava/lang/String;[Ljava/lang/Object;)Ljava/io/PrintStream;

    .line 884
    nop

    .line 886
    :cond_4
    iput p2, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    .line 869
    :cond_5
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 889
    :cond_6
    invoke-direct {p0, v1}, Lio/mesalabs/unica/audio/Sonic;->removePitchSamples(I)V

    .line 890
    return-void

    .line 861
    :cond_7
    :goto_4
    shr-int/lit8 p1, p1, 0x1

    .line 862
    shr-int/lit8 v0, v0, 0x1

    goto :goto_0
.end method

.method private allocateStreamBuffers(II)V
    .locals 1

    .line 236
    div-int/lit16 v0, p1, 0x190

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->minPeriod:I

    .line 237
    div-int/lit8 v0, p1, 0x41

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    .line 238
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    mul-int/lit8 v0, v0, 0x2

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    .line 239
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    .line 240
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int v0, v0, p2

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    .line 241
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    .line 242
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int v0, v0, p2

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    .line 243
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    .line 244
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int v0, v0, p2

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    .line 245
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/Sonic;->downSampleBuffer:[S

    .line 246
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    .line 247
    iput p2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    .line 248
    const/4 p1, 0x0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    .line 249
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    .line 250
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->prevPeriod:I

    .line 251
    return-void
.end method

.method public static changeFloatSpeed([FIFFFFZII)I
    .locals 1

    .line 1046
    new-instance v0, Lio/mesalabs/unica/audio/Sonic;

    invoke-direct {v0, p7, p8}, Lio/mesalabs/unica/audio/Sonic;-><init>(II)V

    .line 1048
    invoke-virtual {v0, p2}, Lio/mesalabs/unica/audio/Sonic;->setSpeed(F)V

    .line 1049
    invoke-virtual {v0, p3}, Lio/mesalabs/unica/audio/Sonic;->setPitch(F)V

    .line 1050
    invoke-virtual {v0, p4}, Lio/mesalabs/unica/audio/Sonic;->setRate(F)V

    .line 1051
    invoke-virtual {v0, p5}, Lio/mesalabs/unica/audio/Sonic;->setVolume(F)V

    .line 1052
    invoke-virtual {v0, p6}, Lio/mesalabs/unica/audio/Sonic;->setChordPitch(Z)V

    .line 1053
    invoke-virtual {v0, p0, p1}, Lio/mesalabs/unica/audio/Sonic;->writeFloatToStream([FI)V

    .line 1054
    invoke-virtual {v0}, Lio/mesalabs/unica/audio/Sonic;->flushStream()V

    .line 1055
    invoke-virtual {v0}, Lio/mesalabs/unica/audio/Sonic;->samplesAvailable()I

    move-result p1

    .line 1056
    invoke-virtual {v0, p0, p1}, Lio/mesalabs/unica/audio/Sonic;->readFloatFromStream([FI)I

    .line 1057
    return p1
.end method

.method private changeSpeed(F)V
    .locals 8

    .line 943
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 944
    nop

    .line 946
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    if-ge v1, v2, :cond_0

    .line 947
    return-void

    .line 946
    :cond_0
    const/4 v1, 0x0

    .line 950
    :cond_1
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    if-lez v2, :cond_2

    .line 951
    invoke-direct {p0, v1}, Lio/mesalabs/unica/audio/Sonic;->copyInputToOutput(I)I

    move-result v2

    .line 952
    add-int/2addr v1, v2

    goto :goto_0

    .line 954
    :cond_2
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    const/4 v3, 0x1

    invoke-direct {p0, v2, v1, v3}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriod([SIZ)I

    move-result v2

    .line 955
    float-to-double v3, p1

    const-wide/high16 v5, 0x3ff0000000000000L    # 1.0

    cmpl-double v7, v3, v5

    if-lez v7, :cond_3

    .line 956
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    invoke-direct {p0, v3, v1, p1, v2}, Lio/mesalabs/unica/audio/Sonic;->skipPitchPeriod([SIFI)I

    move-result v3

    .line 957
    add-int/2addr v2, v3

    add-int/2addr v1, v2

    goto :goto_0

    .line 959
    :cond_3
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    invoke-direct {p0, v3, v1, p1, v2}, Lio/mesalabs/unica/audio/Sonic;->insertPitchPeriod([SIFI)I

    move-result v2

    .line 960
    add-int/2addr v1, v2

    .line 963
    :goto_0
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    add-int/2addr v2, v1

    if-le v2, v0, :cond_1

    .line 964
    invoke-direct {p0, v1}, Lio/mesalabs/unica/audio/Sonic;->removeInputSamples(I)V

    .line 965
    return-void
.end method

.method private copyInputToOutput(I)I
    .locals 2

    .line 402
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    .line 404
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    if-le v0, v1, :cond_0

    .line 405
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    .line 407
    :cond_0
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    invoke-direct {p0, v1, p1, v0}, Lio/mesalabs/unica/audio/Sonic;->copyToOutput([SII)V

    .line 408
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    sub-int/2addr p1, v0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    .line 409
    return v0
.end method

.method private copyToOutput([SII)V
    .locals 6

    .line 393
    invoke-direct {p0, p3}, Lio/mesalabs/unica/audio/Sonic;->enlargeOutputBufferIfNeeded(I)V

    .line 394
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    move-object v0, p0

    move-object v3, p1

    move v4, p2

    move v5, p3

    invoke-direct/range {v0 .. v5}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 395
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr p1, p3

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 396
    return-void
.end method

.method private downSampleInput([SII)V
    .locals 6

    .line 550
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    div-int/2addr v0, p3

    .line 551
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v1, v1, p3

    .line 554
    iget p3, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, p3

    .line 555
    const/4 p3, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_1

    .line 556
    nop

    .line 557
    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_1
    if-ge v3, v1, :cond_0

    .line 558
    mul-int v5, v2, v1

    add-int/2addr v5, p2

    add-int/2addr v5, v3

    aget-short v5, p1, v5

    add-int/2addr v4, v5

    .line 557
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 560
    :cond_0
    div-int/2addr v4, v1

    .line 561
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->downSampleBuffer:[S

    int-to-short v4, v4

    aput-short v4, v3, v2

    .line 555
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 563
    :cond_1
    return-void
.end method

.method private enlargeInputBufferIfNeeded(I)V
    .locals 2

    .line 309
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    add-int/2addr v0, p1

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    if-le v0, v1, :cond_0

    .line 310
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    shr-int/lit8 v1, v1, 0x1

    add-int/2addr v1, p1

    add-int/2addr v0, v1

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    .line 311
    iget-object p1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->inputBufferSize:I

    invoke-direct {p0, p1, v0}, Lio/mesalabs/unica/audio/Sonic;->resize([SI)[S

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    .line 313
    :cond_0
    return-void
.end method

.method private enlargeOutputBufferIfNeeded(I)V
    .locals 2

    .line 299
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr v0, p1

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    if-le v0, v1, :cond_0

    .line 300
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    shr-int/lit8 v1, v1, 0x1

    add-int/2addr v1, p1

    add-int/2addr v0, v1

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    .line 301
    iget-object p1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->outputBufferSize:I

    invoke-direct {p0, p1, v0}, Lio/mesalabs/unica/audio/Sonic;->resize([SI)[S

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    .line 303
    :cond_0
    return-void
.end method

.method private findPitchPeriod([SIZ)I
    .locals 6

    .line 639
    nop

    .line 641
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    const/4 v1, 0x1

    const/16 v2, 0xfa0

    if-le v0, v2, :cond_0

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->quality:I

    if-nez v0, :cond_0

    .line 642
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    div-int/2addr v0, v2

    goto :goto_0

    .line 644
    :cond_0
    const/4 v0, 0x1

    :goto_0
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    if-ne v2, v1, :cond_1

    if-ne v0, v1, :cond_1

    .line 645
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->minPeriod:I

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    invoke-direct {p0, p1, p2, v0, v1}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriodInRange([SIII)I

    move-result p1

    goto :goto_1

    .line 647
    :cond_1
    invoke-direct {p0, p1, p2, v0}, Lio/mesalabs/unica/audio/Sonic;->downSampleInput([SII)V

    .line 648
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->downSampleBuffer:[S

    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->minPeriod:I

    div-int/2addr v3, v0

    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    div-int/2addr v4, v0

    const/4 v5, 0x0

    invoke-direct {p0, v2, v5, v3, v4}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriodInRange([SIII)I

    move-result v2

    .line 650
    if-eq v0, v1, :cond_5

    .line 651
    mul-int v2, v2, v0

    .line 652
    shl-int/lit8 v0, v0, 0x2

    sub-int v3, v2, v0

    .line 653
    add-int/2addr v2, v0

    .line 654
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->minPeriod:I

    if-ge v3, v0, :cond_2

    .line 655
    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->minPeriod:I

    .line 657
    :cond_2
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    if-le v2, v0, :cond_3

    .line 658
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->maxPeriod:I

    .line 660
    :cond_3
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    if-ne v0, v1, :cond_4

    .line 661
    invoke-direct {p0, p1, p2, v3, v2}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriodInRange([SIII)I

    move-result p1

    goto :goto_1

    .line 663
    :cond_4
    invoke-direct {p0, p1, p2, v1}, Lio/mesalabs/unica/audio/Sonic;->downSampleInput([SII)V

    .line 664
    iget-object p1, p0, Lio/mesalabs/unica/audio/Sonic;->downSampleBuffer:[S

    invoke-direct {p0, p1, v5, v3, v2}, Lio/mesalabs/unica/audio/Sonic;->findPitchPeriodInRange([SIII)I

    move-result p1

    goto :goto_1

    .line 650
    :cond_5
    move p1, v2

    .line 668
    :goto_1
    iget p2, p0, Lio/mesalabs/unica/audio/Sonic;->minDiff:I

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->maxDiff:I

    invoke-direct {p0, p2, v0, p3}, Lio/mesalabs/unica/audio/Sonic;->prevPeriodBetter(IIZ)Z

    move-result p2

    if-eqz p2, :cond_6

    .line 669
    iget p2, p0, Lio/mesalabs/unica/audio/Sonic;->prevPeriod:I

    goto :goto_2

    .line 671
    :cond_6
    move p2, p1

    .line 673
    :goto_2
    iget p3, p0, Lio/mesalabs/unica/audio/Sonic;->minDiff:I

    iput p3, p0, Lio/mesalabs/unica/audio/Sonic;->prevMinDiff:I

    .line 674
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->prevPeriod:I

    .line 675
    return p2
.end method

.method private findPitchPeriodInRange([SIII)I
    .locals 9

    .line 573
    nop

    .line 574
    nop

    .line 576
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, v0

    .line 577
    const/4 v0, 0x0

    const/16 v1, 0xff

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-gt p3, p4, :cond_4

    .line 578
    nop

    .line 579
    const/4 v5, 0x0

    const/4 v6, 0x0

    :goto_1
    if-ge v5, p3, :cond_1

    .line 580
    add-int v7, p2, v5

    aget-short v7, p1, v7

    .line 581
    add-int v8, p2, p3

    add-int/2addr v8, v5

    aget-short v8, p1, v8

    .line 582
    if-lt v7, v8, :cond_0

    sub-int/2addr v7, v8

    goto :goto_2

    :cond_0
    sub-int v7, v8, v7

    :goto_2
    add-int/2addr v6, v7

    .line 579
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 587
    :cond_1
    mul-int v5, v6, v3

    mul-int v7, v2, p3

    if-ge v5, v7, :cond_2

    .line 588
    nop

    .line 589
    move v3, p3

    move v2, v6

    .line 591
    :cond_2
    mul-int v5, v6, v1

    mul-int v7, v4, p3

    if-le v5, v7, :cond_3

    .line 592
    nop

    .line 593
    move v1, p3

    move v4, v6

    .line 577
    :cond_3
    add-int/lit8 p3, p3, 0x1

    goto :goto_0

    .line 596
    :cond_4
    div-int/2addr v2, v3

    iput v2, p0, Lio/mesalabs/unica/audio/Sonic;->minDiff:I

    .line 597
    div-int/2addr v4, v1

    iput v4, p0, Lio/mesalabs/unica/audio/Sonic;->maxDiff:I

    .line 599
    return v3
.end method

.method private findSincCoefficient(III)I
    .locals 2

    .line 795
    nop

    .line 796
    mul-int/lit8 p1, p1, 0x32

    mul-int/lit8 p2, p2, 0x32

    div-int v0, p2, p3

    add-int/2addr v0, p1

    .line 797
    add-int/lit8 v1, v0, 0x1

    .line 798
    mul-int p1, p1, p3

    add-int/2addr p1, p2

    mul-int p2, v0, p3

    sub-int/2addr p1, p2

    .line 799
    sget-object p2, Lio/mesalabs/unica/audio/Sonic;->sincTable:[S

    aget-short p2, p2, v0

    .line 800
    sget-object v0, Lio/mesalabs/unica/audio/Sonic;->sincTable:[S

    aget-short v0, v0, v1

    .line 802
    sub-int v1, p3, p1

    mul-int p2, p2, v1

    mul-int v0, v0, p1

    add-int/2addr p2, v0

    shl-int/lit8 p1, p2, 0x1

    div-int/2addr p1, p3

    return p1
.end method

.method private getSign(I)I
    .locals 0

    .line 807
    if-ltz p1, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, -0x1

    :goto_0
    return p1
.end method

.method private insertPitchPeriod([SIFI)I
    .locals 10

    .line 924
    const/high16 v0, 0x3f000000    # 0.5f

    const/high16 v1, 0x3f800000    # 1.0f

    cmpg-float v0, p3, v0

    if-gez v0, :cond_0

    .line 925
    int-to-float v0, p4

    mul-float v0, v0, p3

    sub-float/2addr v1, p3

    div-float/2addr v0, v1

    float-to-int p3, v0

    goto :goto_0

    .line 927
    :cond_0
    nop

    .line 928
    int-to-float v0, p4

    const/high16 v2, 0x40000000    # 2.0f

    mul-float v2, v2, p3

    sub-float/2addr v2, v1

    mul-float v0, v0, v2

    sub-float/2addr v1, p3

    div-float/2addr v0, v1

    float-to-int p3, v0

    iput p3, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    move p3, p4

    .line 930
    :goto_0
    add-int v9, p4, p3

    invoke-direct {p0, v9}, Lio/mesalabs/unica/audio/Sonic;->enlargeOutputBufferIfNeeded(I)V

    .line 931
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    move-object v0, p0

    move-object v3, p1

    move v4, p2

    move v5, p4

    invoke-direct/range {v0 .. v5}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 932
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int v4, v0, p4

    add-int v6, p2, p4

    move-object v0, p0

    move v1, p3

    move-object v5, p1

    move-object v7, p1

    move v8, p2

    invoke-direct/range {v0 .. v8}, Lio/mesalabs/unica/audio/Sonic;->overlapAdd(II[SI[SI[SI)V

    .line 934
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr p1, v9

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 935
    return p3
.end method

.method private interpolate([SIII)S
    .locals 6

    .line 819
    nop

    .line 820
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    mul-int v0, v0, p3

    .line 821
    iget p3, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    mul-int p3, p3, p4

    .line 822
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    add-int/lit8 v1, v1, 0x1

    mul-int v1, v1, p4

    .line 823
    sub-int p4, v1, v0

    add-int/lit8 p4, p4, -0x1

    .line 824
    sub-int/2addr v1, p3

    .line 827
    nop

    .line 829
    const/4 p3, 0x0

    const/4 v0, 0x0

    const/4 v2, 0x0

    :goto_0
    const/16 v3, 0xc

    if-ge p3, v3, :cond_1

    .line 830
    invoke-direct {p0, p3, p4, v1}, Lio/mesalabs/unica/audio/Sonic;->findSincCoefficient(III)I

    move-result v3

    .line 832
    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v4, v4, p3

    add-int/2addr v4, p2

    aget-short v4, p1, v4

    mul-int v4, v4, v3

    .line 833
    invoke-direct {p0, v2}, Lio/mesalabs/unica/audio/Sonic;->getSign(I)I

    move-result v3

    .line 834
    add-int/2addr v2, v4

    .line 835
    invoke-direct {p0, v2}, Lio/mesalabs/unica/audio/Sonic;->getSign(I)I

    move-result v5

    if-eq v3, v5, :cond_0

    invoke-direct {p0, v4}, Lio/mesalabs/unica/audio/Sonic;->getSign(I)I

    move-result v4

    if-ne v4, v3, :cond_0

    .line 837
    add-int/2addr v0, v3

    .line 829
    :cond_0
    add-int/lit8 p3, p3, 0x1

    goto :goto_0

    .line 841
    :cond_1
    if-lez v0, :cond_2

    .line 842
    const/16 p1, 0x7fff

    return p1

    .line 843
    :cond_2
    if-gez v0, :cond_3

    .line 844
    const/16 p1, -0x8000

    return p1

    .line 846
    :cond_3
    shr-int/lit8 p1, v2, 0x10

    int-to-short p1, p1

    return p1
.end method

.method private move([SI[SII)V
    .locals 1

    .line 124
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p4, p4, v0

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, v0

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p5, p5, v0

    invoke-static {p3, p4, p1, p2, p5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 125
    return-void
.end method

.method private moveNewSamplesToPitchBuffer(I)V
    .locals 7

    .line 741
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    sub-int/2addr v0, p1

    .line 743
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    add-int/2addr v1, v0

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    if-le v1, v2, :cond_0

    .line 744
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    shr-int/lit8 v2, v2, 0x1

    add-int/2addr v2, v0

    add-int/2addr v1, v2

    iput v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    .line 745
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBufferSize:I

    invoke-direct {p0, v1, v2}, Lio/mesalabs/unica/audio/Sonic;->resize([SI)[S

    move-result-object v1

    iput-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    .line 747
    :cond_0
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    move-object v1, p0

    move v5, p1

    move v6, v0

    invoke-direct/range {v1 .. v6}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 748
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 749
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    add-int/2addr p1, v0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    .line 750
    return-void
.end method

.method private overlapAdd(II[SI[SI[SI)V
    .locals 10

    .line 690
    move v0, p1

    move v1, p2

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_1

    .line 691
    mul-int v4, p4, v1

    add-int/2addr v4, v3

    .line 692
    mul-int v5, p8, v1

    add-int/2addr v5, v3

    .line 693
    mul-int v6, p6, v1

    add-int/2addr v6, v3

    .line 694
    const/4 v7, 0x0

    :goto_1
    if-ge v7, v0, :cond_0

    .line 695
    aget-short v8, p5, v6

    sub-int v9, v0, v7

    mul-int v8, v8, v9

    aget-short v9, p7, v5

    mul-int v9, v9, v7

    add-int/2addr v8, v9

    div-int/2addr v8, v0

    int-to-short v8, v8

    aput-short v8, p3, v4

    .line 696
    add-int/2addr v4, v1

    .line 697
    add-int/2addr v6, v1

    .line 698
    add-int/2addr v5, v1

    .line 694
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 690
    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 701
    :cond_1
    return-void
.end method

.method private overlapAddWithSeparation(III[SI[SI[SI)V
    .locals 12

    .line 716
    move v0, p1

    move v1, p2

    move v2, p3

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v1, :cond_3

    .line 717
    mul-int v5, p5, v1

    add-int/2addr v5, v4

    .line 718
    mul-int v6, p9, v1

    add-int/2addr v6, v4

    .line 719
    mul-int v7, p7, v1

    add-int/2addr v7, v4

    .line 720
    const/4 v8, 0x0

    :goto_1
    add-int v9, v0, v2

    if-ge v8, v9, :cond_2

    .line 721
    if-ge v8, v2, :cond_0

    .line 722
    aget-short v9, p6, v7

    sub-int v10, v0, v8

    mul-int v9, v9, v10

    div-int/2addr v9, v0

    int-to-short v9, v9

    aput-short v9, p4, v5

    .line 723
    add-int/2addr v7, v1

    goto :goto_2

    .line 724
    :cond_0
    if-ge v8, v0, :cond_1

    .line 725
    aget-short v9, p6, v7

    sub-int v10, v0, v8

    mul-int v9, v9, v10

    aget-short v10, p8, v6

    sub-int v11, v8, v2

    mul-int v10, v10, v11

    add-int/2addr v9, v10

    div-int/2addr v9, v0

    int-to-short v9, v9

    aput-short v9, p4, v5

    .line 726
    add-int/2addr v7, v1

    .line 727
    add-int/2addr v6, v1

    goto :goto_2

    .line 729
    :cond_1
    aget-short v9, p8, v6

    sub-int v10, v8, v2

    mul-int v9, v9, v10

    div-int/2addr v9, v0

    int-to-short v9, v9

    aput-short v9, p4, v5

    .line 730
    add-int/2addr v6, v1

    .line 732
    :goto_2
    add-int/2addr v5, v1

    .line 720
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 716
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 735
    :cond_3
    return-void
.end method

.method private prevPeriodBetter(IIZ)Z
    .locals 2

    .line 609
    const/4 v0, 0x0

    if-eqz p1, :cond_4

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->prevPeriod:I

    if-nez v1, :cond_0

    goto :goto_0

    .line 612
    :cond_0
    if-eqz p3, :cond_2

    .line 613
    mul-int/lit8 p3, p1, 0x3

    if-le p2, p3, :cond_1

    .line 615
    return v0

    .line 617
    :cond_1
    mul-int/lit8 p1, p1, 0x2

    iget p2, p0, Lio/mesalabs/unica/audio/Sonic;->prevMinDiff:I

    mul-int/lit8 p2, p2, 0x3

    if-gt p1, p2, :cond_3

    .line 619
    return v0

    .line 622
    :cond_2
    iget p2, p0, Lio/mesalabs/unica/audio/Sonic;->prevMinDiff:I

    if-gt p1, p2, :cond_3

    .line 623
    return v0

    .line 626
    :cond_3
    const/4 p1, 0x1

    return p1

    .line 610
    :cond_4
    :goto_0
    return v0
.end method

.method private processStreamInput()V
    .locals 8

    .line 970
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 971
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->speed:F

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    div-float/2addr v1, v2

    .line 972
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->rate:F

    .line 974
    iget-boolean v3, p0, Lio/mesalabs/unica/audio/Sonic;->useChordPitch:Z

    if-nez v3, :cond_0

    .line 975
    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    mul-float v2, v2, v3

    .line 977
    :cond_0
    float-to-double v3, v1

    const-wide v5, 0x3ff0000a7c5ac472L    # 1.00001

    cmpl-double v7, v3, v5

    if-gtz v7, :cond_2

    const-wide v5, 0x3fefffeb074a771dL    # 0.99999

    cmpg-double v7, v3, v5

    if-gez v7, :cond_1

    goto :goto_0

    .line 980
    :cond_1
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    const/4 v4, 0x0

    invoke-direct {p0, v1, v4, v3}, Lio/mesalabs/unica/audio/Sonic;->copyToOutput([SII)V

    .line 981
    iput v4, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    goto :goto_1

    .line 978
    :cond_2
    :goto_0
    invoke-direct {p0, v1}, Lio/mesalabs/unica/audio/Sonic;->changeSpeed(F)V

    .line 983
    :goto_1
    iget-boolean v1, p0, Lio/mesalabs/unica/audio/Sonic;->useChordPitch:Z

    const/high16 v3, 0x3f800000    # 1.0f

    if-eqz v1, :cond_3

    .line 984
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    cmpl-float v1, v1, v3

    if-eqz v1, :cond_4

    .line 985
    invoke-direct {p0, v0}, Lio/mesalabs/unica/audio/Sonic;->adjustPitch(I)V

    goto :goto_2

    .line 987
    :cond_3
    cmpl-float v1, v2, v3

    if-eqz v1, :cond_4

    .line 988
    invoke-direct {p0, v2, v0}, Lio/mesalabs/unica/audio/Sonic;->adjustRate(FI)V

    .line 990
    :cond_4
    :goto_2
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->volume:F

    cmpl-float v1, v1, v3

    if-eqz v1, :cond_5

    .line 992
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    sub-int/2addr v2, v0

    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->volume:F

    invoke-direct {p0, v1, v0, v2, v3}, Lio/mesalabs/unica/audio/Sonic;->scaleSamples([SIIF)V

    .line 995
    :cond_5
    return-void
.end method

.method private removeInputSamples(I)V
    .locals 7

    .line 381
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    sub-int/2addr v0, p1

    .line 383
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    const/4 v3, 0x0

    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    move-object v1, p0

    move v5, p1

    move v6, v0

    invoke-direct/range {v1 .. v6}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 384
    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 385
    return-void
.end method

.method private removePitchSamples(I)V
    .locals 6

    .line 756
    if-nez p1, :cond_0

    .line 757
    return-void

    .line 759
    :cond_0
    iget-object v1, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->pitchBuffer:[S

    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    sub-int v5, v0, p1

    const/4 v2, 0x0

    move-object v0, p0

    move v4, p1

    invoke-direct/range {v0 .. v5}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 760
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    sub-int/2addr v0, p1

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    .line 761
    return-void
.end method

.method private resize([SI)[S
    .locals 2

    .line 108
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, v0

    .line 109
    new-array v0, p2, [S

    .line 110
    array-length v1, p1

    if-gt v1, p2, :cond_0

    array-length p2, p1

    .line 112
    :cond_0
    const/4 v1, 0x0

    invoke-static {p1, v1, v0, v1, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 113
    return-object v0
.end method

.method private scaleSamples([SIIF)V
    .locals 2

    .line 135
    const/high16 v0, 0x45800000    # 4096.0f

    mul-float p4, p4, v0

    float-to-int p4, p4

    .line 136
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, v0

    .line 137
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p3, p3, v0

    add-int/2addr p3, p2

    .line 139
    nop

    :goto_0
    if-ge p2, p3, :cond_2

    .line 141
    aget-short v0, p1, p2

    mul-int v0, v0, p4

    shr-int/lit8 v0, v0, 0xc

    .line 142
    const/16 v1, 0x7fff

    if-le v0, v1, :cond_0

    .line 143
    const/16 v0, 0x7fff

    goto :goto_1

    .line 144
    :cond_0
    const/16 v1, -0x7fff

    if-ge v0, v1, :cond_1

    .line 145
    const/16 v0, -0x7fff

    .line 147
    :cond_1
    :goto_1
    int-to-short v0, v0

    aput-short v0, p1, p2

    .line 139
    add-int/lit8 p2, p2, 0x1

    goto :goto_0

    .line 149
    :cond_2
    return-void
.end method

.method private skipPitchPeriod([SIFI)I
    .locals 9

    .line 902
    const/high16 v0, 0x3f800000    # 1.0f

    const/high16 v1, 0x40000000    # 2.0f

    cmpl-float v2, p3, v1

    if-ltz v2, :cond_0

    .line 903
    int-to-float v1, p4

    sub-float/2addr p3, v0

    div-float/2addr v1, p3

    float-to-int p3, v1

    goto :goto_0

    .line 905
    :cond_0
    nop

    .line 906
    int-to-float v2, p4

    sub-float/2addr v1, p3

    mul-float v2, v2, v1

    sub-float/2addr p3, v0

    div-float/2addr v2, p3

    float-to-int p3, v2

    iput p3, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    move p3, p4

    .line 908
    :goto_0
    invoke-direct {p0, p3}, Lio/mesalabs/unica/audio/Sonic;->enlargeOutputBufferIfNeeded(I)V

    .line 909
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int v8, p2, p4

    move-object v0, p0

    move v1, p3

    move-object v5, p1

    move v6, p2

    move-object v7, p1

    invoke-direct/range {v0 .. v8}, Lio/mesalabs/unica/audio/Sonic;->overlapAdd(II[SI[SI[SI)V

    .line 911
    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    add-int/2addr p1, p3

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 912
    return p3
.end method


# virtual methods
.method public flushStream()V
    .locals 6

    .line 514
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 515
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->speed:F

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    div-float/2addr v1, v2

    .line 516
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->rate:F

    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    mul-float v2, v2, v3

    .line 517
    iget v3, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    int-to-float v4, v0

    div-float/2addr v4, v1

    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    int-to-float v1, v1

    add-float/2addr v4, v1

    div-float/2addr v4, v2

    const/high16 v1, 0x3f000000    # 0.5f

    add-float/2addr v4, v1

    float-to-int v1, v4

    add-int/2addr v3, v1

    .line 520
    iget v1, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int/lit8 v1, v1, 0x2

    add-int/2addr v1, v0

    invoke-direct {p0, v1}, Lio/mesalabs/unica/audio/Sonic;->enlargeInputBufferIfNeeded(I)V

    .line 521
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    iget v4, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int/lit8 v4, v4, 0x2

    iget v5, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v4, v4, v5

    if-ge v2, v4, :cond_0

    .line 522
    iget-object v4, p0, Lio/mesalabs/unica/audio/Sonic;->inputBuffer:[S

    iget v5, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v5, v5, v0

    add-int/2addr v5, v2

    aput-short v1, v4, v5

    .line 521
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 524
    :cond_0
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->maxRequired:I

    mul-int/lit8 v2, v2, 0x2

    add-int/2addr v0, v2

    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 525
    const/4 v0, 0x0

    invoke-virtual {p0, v0, v1}, Lio/mesalabs/unica/audio/Sonic;->writeShortToStream([SI)V

    .line 527
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    if-le v0, v3, :cond_1

    .line 528
    iput v3, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 531
    :cond_1
    iput v1, p0, Lio/mesalabs/unica/audio/Sonic;->numInputSamples:I

    .line 532
    iput v1, p0, Lio/mesalabs/unica/audio/Sonic;->remainingInputToCopy:I

    .line 533
    iput v1, p0, Lio/mesalabs/unica/audio/Sonic;->numPitchSamples:I

    .line 534
    return-void
.end method

.method public getChordPitch()Z
    .locals 1

    .line 195
    iget-boolean v0, p0, Lio/mesalabs/unica/audio/Sonic;->useChordPitch:Z

    return v0
.end method

.method public getNumChannels()I
    .locals 1

    .line 285
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    return v0
.end method

.method public getPitch()F
    .locals 1

    .line 167
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    return v0
.end method

.method public getQuality()I
    .locals 1

    .line 208
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->quality:I

    return v0
.end method

.method public getRate()F
    .locals 1

    .line 180
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->rate:F

    return v0
.end method

.method public getSampleRate()I
    .locals 1

    .line 272
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    return v0
.end method

.method public getSpeed()F
    .locals 1

    .line 154
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->speed:F

    return v0
.end method

.method public getVolume()F
    .locals 1

    .line 221
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->volume:F

    return v0
.end method

.method public readBytesFromStream([BI)I
    .locals 8

    .line 488
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int/lit8 v0, v0, 0x2

    div-int/2addr p2, v0

    .line 489
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 490
    nop

    .line 492
    const/4 v1, 0x0

    if-eqz v0, :cond_3

    if-nez p2, :cond_0

    goto :goto_2

    .line 495
    :cond_0
    if-le v0, p2, :cond_1

    .line 496
    sub-int/2addr v0, p2

    .line 497
    goto :goto_0

    .line 495
    :cond_1
    move p2, v0

    const/4 v0, 0x0

    .line 499
    :goto_0
    nop

    :goto_1
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v2, v2, p2

    if-ge v1, v2, :cond_2

    .line 500
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    aget-short v2, v2, v1

    .line 501
    shl-int/lit8 v3, v1, 0x1

    and-int/lit16 v4, v2, 0xff

    int-to-byte v4, v4

    aput-byte v4, p1, v3

    .line 502
    add-int/lit8 v3, v3, 0x1

    shr-int/lit8 v2, v2, 0x8

    int-to-byte v2, v2

    aput-byte v2, p1, v3

    .line 499
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 504
    :cond_2
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    const/4 v4, 0x0

    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    move-object v2, p0

    move v6, p2

    move v7, v0

    invoke-direct/range {v2 .. v7}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 505
    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 506
    mul-int/lit8 p2, p2, 0x2

    iget p1, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int p2, p2, p1

    return p2

    .line 493
    :cond_3
    :goto_2
    return v1
.end method

.method public readFloatFromStream([FI)I
    .locals 8

    .line 418
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 419
    nop

    .line 421
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 422
    return v1

    .line 424
    :cond_0
    if-le v0, p2, :cond_1

    .line 425
    sub-int/2addr v0, p2

    .line 426
    goto :goto_0

    .line 424
    :cond_1
    move p2, v0

    const/4 v0, 0x0

    .line 428
    :goto_0
    nop

    :goto_1
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v2, v2, p2

    if-ge v1, v2, :cond_2

    .line 429
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    aget-short v2, v2, v1

    int-to-float v2, v2

    const v3, 0x46fffe00    # 32767.0f

    div-float/2addr v2, v3

    aput v2, p1, v1

    .line 428
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 431
    :cond_2
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    const/4 v4, 0x0

    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    move-object v2, p0

    move v6, p2

    move v7, v0

    invoke-direct/range {v2 .. v7}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 432
    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 433
    return p2
.end method

.method public readShortFromStream([SI)I
    .locals 8

    .line 442
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 443
    nop

    .line 445
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 446
    return v1

    .line 448
    :cond_0
    if-le v0, p2, :cond_1

    .line 449
    sub-int v1, v0, p2

    .line 450
    goto :goto_0

    .line 448
    :cond_1
    move p2, v0

    .line 452
    :goto_0
    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    const/4 v6, 0x0

    const/4 v4, 0x0

    move-object v2, p0

    move-object v3, p1

    move v7, p2

    invoke-direct/range {v2 .. v7}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 453
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    move v6, p2

    move v7, v1

    invoke-direct/range {v2 .. v7}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 454
    iput v1, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 455
    return p2
.end method

.method public readUnsignedByteFromStream([BI)I
    .locals 8

    .line 464
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 465
    nop

    .line 467
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 468
    return v1

    .line 470
    :cond_0
    if-le v0, p2, :cond_1

    .line 471
    sub-int/2addr v0, p2

    .line 472
    goto :goto_0

    .line 470
    :cond_1
    move p2, v0

    const/4 v0, 0x0

    .line 474
    :goto_0
    nop

    :goto_1
    iget v2, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    mul-int v2, v2, p2

    if-ge v1, v2, :cond_2

    .line 475
    iget-object v2, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    aget-short v2, v2, v1

    shr-int/lit8 v2, v2, 0x8

    add-int/lit16 v2, v2, 0x80

    int-to-byte v2, v2

    aput-byte v2, p1, v1

    .line 474
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 477
    :cond_2
    iget-object v3, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    const/4 v4, 0x0

    iget-object v5, p0, Lio/mesalabs/unica/audio/Sonic;->outputBuffer:[S

    move-object v2, p0

    move v6, p2

    move v7, v0

    invoke-direct/range {v2 .. v7}, Lio/mesalabs/unica/audio/Sonic;->move([SI[SII)V

    .line 478
    iput v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    .line 479
    return p2
.end method

.method public samplesAvailable()I
    .locals 1

    .line 539
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numOutputSamples:I

    return v0
.end method

.method public setChordPitch(Z)V
    .locals 0

    .line 202
    iput-boolean p1, p0, Lio/mesalabs/unica/audio/Sonic;->useChordPitch:Z

    .line 203
    return-void
.end method

.method public setNumChannels(I)V
    .locals 1

    .line 292
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->sampleRate:I

    invoke-direct {p0, v0, p1}, Lio/mesalabs/unica/audio/Sonic;->allocateStreamBuffers(II)V

    .line 293
    return-void
.end method

.method public setPitch(F)V
    .locals 0

    .line 174
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->pitch:F

    .line 175
    return-void
.end method

.method public setQuality(I)V
    .locals 0

    .line 215
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->quality:I

    .line 216
    return-void
.end method

.method public setRate(F)V
    .locals 0

    .line 187
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->rate:F

    .line 188
    const/4 p1, 0x0

    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->oldRatePosition:I

    .line 189
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->newRatePosition:I

    .line 190
    return-void
.end method

.method public setSampleRate(I)V
    .locals 1

    .line 279
    iget v0, p0, Lio/mesalabs/unica/audio/Sonic;->numChannels:I

    invoke-direct {p0, p1, v0}, Lio/mesalabs/unica/audio/Sonic;->allocateStreamBuffers(II)V

    .line 280
    return-void
.end method

.method public setSpeed(F)V
    .locals 0

    .line 161
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->speed:F

    .line 162
    return-void
.end method

.method public setVolume(F)V
    .locals 0

    .line 228
    iput p1, p0, Lio/mesalabs/unica/audio/Sonic;->volume:F

    .line 229
    return-void
.end method

.method public sonicChangeShortSpeed([SIFFFFZII)I
    .locals 1

    .line 1072
    new-instance v0, Lio/mesalabs/unica/audio/Sonic;

    invoke-direct {v0, p8, p9}, Lio/mesalabs/unica/audio/Sonic;-><init>(II)V

    .line 1074
    invoke-virtual {v0, p3}, Lio/mesalabs/unica/audio/Sonic;->setSpeed(F)V

    .line 1075
    invoke-virtual {v0, p4}, Lio/mesalabs/unica/audio/Sonic;->setPitch(F)V

    .line 1076
    invoke-virtual {v0, p5}, Lio/mesalabs/unica/audio/Sonic;->setRate(F)V

    .line 1077
    invoke-virtual {v0, p6}, Lio/mesalabs/unica/audio/Sonic;->setVolume(F)V

    .line 1078
    invoke-virtual {v0, p7}, Lio/mesalabs/unica/audio/Sonic;->setChordPitch(Z)V

    .line 1079
    invoke-virtual {v0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->writeShortToStream([SI)V

    .line 1080
    invoke-virtual {v0}, Lio/mesalabs/unica/audio/Sonic;->flushStream()V

    .line 1081
    invoke-virtual {v0}, Lio/mesalabs/unica/audio/Sonic;->samplesAvailable()I

    move-result p2

    .line 1082
    invoke-virtual {v0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->readShortFromStream([SI)I

    .line 1083
    return p2
.end method

.method public writeBytesToStream([BI)V
    .locals 0

    .line 1030
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->addBytesToInputBuffer([BI)V

    .line 1031
    invoke-direct {p0}, Lio/mesalabs/unica/audio/Sonic;->processStreamInput()V

    .line 1032
    return-void
.end method

.method public writeFloatToStream([FI)V
    .locals 0

    .line 1002
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->addFloatSamplesToInputBuffer([FI)V

    .line 1003
    invoke-direct {p0}, Lio/mesalabs/unica/audio/Sonic;->processStreamInput()V

    .line 1004
    return-void
.end method

.method public writeShortToStream([SI)V
    .locals 0

    .line 1011
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->addShortSamplesToInputBuffer([SI)V

    .line 1012
    invoke-direct {p0}, Lio/mesalabs/unica/audio/Sonic;->processStreamInput()V

    .line 1013
    return-void
.end method

.method public writeUnsignedByteToStream([BI)V
    .locals 0

    .line 1021
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;->addUnsignedByteSamplesToInputBuffer([BI)V

    .line 1022
    invoke-direct {p0}, Lio/mesalabs/unica/audio/Sonic;->processStreamInput()V

    .line 1023
    return-void
.end method
