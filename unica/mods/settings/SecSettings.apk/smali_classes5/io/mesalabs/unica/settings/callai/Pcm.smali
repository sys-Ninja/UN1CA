.class final Lio/mesalabs/unica/settings/callai/Pcm;
.super Ljava/lang/Object;
.source "Pcm.java"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static fromWavOrRaw([B)[S
    .registers 10

    .line 50
    nop

    .line 51
    array-length v0, p0

    const/16 v1, 0x2c

    const/4 v2, 0x2

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-le v0, v1, :cond_6f

    aget-byte v0, p0, v4

    const/16 v1, 0x52

    if-ne v0, v1, :cond_6f

    aget-byte v0, p0, v3

    const/16 v1, 0x49

    if-ne v0, v1, :cond_6f

    aget-byte v0, p0, v2

    const/16 v1, 0x46

    if-ne v0, v1, :cond_6f

    const/4 v0, 0x3

    aget-byte v0, p0, v0

    if-ne v0, v1, :cond_6f

    .line 52
    const/16 v0, 0xc

    .line 53
    :goto_22
    add-int/lit8 v1, v0, 0x8

    array-length v5, p0

    if-gt v1, v5, :cond_70

    .line 54
    add-int/lit8 v5, v0, 0x4

    aget-byte v5, p0, v5

    and-int/lit16 v5, v5, 0xff

    add-int/lit8 v6, v0, 0x5

    aget-byte v6, p0, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x8

    or-int/2addr v5, v6

    add-int/lit8 v6, v0, 0x6

    aget-byte v6, p0, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x10

    or-int/2addr v5, v6

    add-int/lit8 v6, v0, 0x7

    aget-byte v6, p0, v6

    and-int/lit16 v6, v6, 0xff

    shl-int/lit8 v6, v6, 0x18

    or-int/2addr v5, v6

    .line 58
    aget-byte v6, p0, v0

    const/16 v7, 0x64

    if-ne v6, v7, :cond_66

    add-int/lit8 v6, v0, 0x1

    aget-byte v6, p0, v6

    const/16 v7, 0x61

    if-ne v6, v7, :cond_66

    add-int/lit8 v6, v0, 0x2

    aget-byte v6, p0, v6

    const/16 v8, 0x74

    if-ne v6, v8, :cond_66

    add-int/lit8 v0, v0, 0x3

    aget-byte v0, p0, v0

    if-ne v0, v7, :cond_66

    move v0, v3

    goto :goto_67

    :cond_66
    move v0, v4

    .line 60
    :goto_67
    nop

    .line 61
    if-eqz v0, :cond_6c

    .line 62
    move v0, v1

    goto :goto_70

    .line 64
    :cond_6c
    add-int v0, v1, v5

    .line 65
    goto :goto_22

    .line 67
    :cond_6f
    move v0, v4

    :cond_70
    :goto_70
    array-length v1, p0

    sub-int/2addr v1, v0

    div-int/2addr v1, v2

    .line 68
    new-array v2, v1, [S

    .line 69
    nop

    :goto_76
    if-ge v4, v1, :cond_8b

    .line 70
    mul-int/lit8 v5, v4, 0x2

    add-int/2addr v5, v0

    aget-byte v6, p0, v5

    and-int/lit16 v6, v6, 0xff

    .line 71
    add-int/2addr v5, v3

    aget-byte v5, p0, v5

    .line 72
    shl-int/lit8 v5, v5, 0x8

    or-int/2addr v5, v6

    int-to-short v5, v5

    aput-short v5, v2, v4

    .line 69
    add-int/lit8 v4, v4, 0x1

    goto :goto_76

    .line 74
    :cond_8b
    return-object v2
.end method

.method private static putAscii([BILjava/lang/String;)V
    .registers 6

    .line 102
    const/4 v0, 0x0

    :goto_1
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_13

    .line 103
    add-int v1, p1, v0

    invoke-virtual {p2, v0}, Ljava/lang/String;->charAt(I)C

    move-result v2

    int-to-byte v2, v2

    aput-byte v2, p0, v1

    .line 102
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 105
    :cond_13
    return-void
.end method

.method private static putInt([BII)V
    .registers 5

    .line 108
    int-to-byte v0, p2

    aput-byte v0, p0, p1

    .line 109
    add-int/lit8 v0, p1, 0x1

    shr-int/lit8 v1, p2, 0x8

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 110
    add-int/lit8 v0, p1, 0x2

    shr-int/lit8 v1, p2, 0x10

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 111
    add-int/lit8 p1, p1, 0x3

    shr-int/lit8 p2, p2, 0x18

    int-to-byte p2, p2

    aput-byte p2, p0, p1

    .line 112
    return-void
.end method

.method private static putShort([BII)V
    .registers 4

    .line 115
    int-to-byte v0, p2

    aput-byte v0, p0, p1

    .line 116
    add-int/lit8 p1, p1, 0x1

    shr-int/lit8 p2, p2, 0x8

    int-to-byte p2, p2

    aput-byte p2, p0, p1

    .line 117
    return-void
.end method

.method static resample([SIII)[S
    .registers 20

    .line 12
    move-object/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    move/from16 v3, p3

    const/4 v4, 0x0

    if-ne v2, v3, :cond_11

    .line 13
    new-array v2, v1, [S

    .line 14
    invoke-static {v0, v4, v2, v4, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 15
    return-object v2

    .line 17
    :cond_11
    int-to-long v5, v1

    int-to-long v7, v3

    mul-long/2addr v7, v5

    int-to-long v1, v2

    div-long/2addr v7, v1

    long-to-int v1, v7

    .line 18
    new-array v2, v1, [S

    .line 19
    nop

    :goto_1a
    if-ge v4, v1, :cond_56

    .line 20
    int-to-long v7, v4

    mul-long/2addr v7, v5

    int-to-long v9, v1

    div-long/2addr v7, v9

    .line 21
    add-int/lit8 v3, v4, 0x1

    int-to-long v11, v3

    mul-long/2addr v11, v5

    div-long/2addr v11, v9

    .line 22
    cmp-long v9, v11, v7

    const-wide/16 v13, 0x1

    if-gtz v9, :cond_2d

    .line 23
    add-long v11, v7, v13

    .line 25
    :cond_2d
    cmp-long v9, v11, v5

    if-lez v9, :cond_32

    .line 26
    move-wide v11, v5

    .line 28
    :cond_32
    nop

    .line 29
    const-wide/16 v9, 0x0

    move-wide/from16 p1, v13

    move-wide v13, v7

    :goto_38
    cmp-long v15, v13, v11

    if-gez v15, :cond_4a

    .line 30
    long-to-int v15, v13

    aget-short v15, v0, v15

    move/from16 p3, v1

    int-to-long v0, v15

    add-long/2addr v9, v0

    .line 29
    add-long v13, v13, p1

    move-object/from16 v0, p0

    move/from16 v1, p3

    goto :goto_38

    .line 32
    :cond_4a
    move/from16 p3, v1

    sub-long/2addr v11, v7

    div-long/2addr v9, v11

    long-to-int v0, v9

    int-to-short v0, v0

    aput-short v0, v2, v4

    .line 19
    move-object/from16 v0, p0

    move v4, v3

    goto :goto_1a

    .line 34
    :cond_56
    return-object v2
.end method

.method static rms([SI)I
    .registers 9

    .line 38
    const/4 v0, 0x0

    if-gtz p1, :cond_4

    .line 39
    return v0

    .line 41
    :cond_4
    nop

    .line 42
    const-wide/16 v1, 0x0

    :goto_7
    if-ge v0, p1, :cond_14

    .line 43
    aget-short v3, p0, v0

    int-to-long v3, v3

    aget-short v5, p0, v0

    int-to-long v5, v5

    mul-long/2addr v3, v5

    add-long/2addr v1, v3

    .line 42
    add-int/lit8 v0, v0, 0x1

    goto :goto_7

    .line 45
    :cond_14
    long-to-double v0, v1

    int-to-double p0, p1

    div-double/2addr v0, p0

    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-int p0, p0

    return p0
.end method

.method static toWav([SII)[B
    .registers 11

    .line 79
    mul-int/lit8 v0, p1, 0x2

    .line 80
    add-int/lit8 v1, v0, 0x2c

    new-array v1, v1, [B

    .line 81
    const-string v2, "RIFF"

    const/4 v3, 0x0

    invoke-static {v1, v3, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->putAscii([BILjava/lang/String;)V

    .line 82
    add-int/lit8 v2, v0, 0x24

    const/4 v4, 0x4

    invoke-static {v1, v4, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->putInt([BII)V

    .line 83
    const-string v2, "WAVE"

    const/16 v4, 0x8

    invoke-static {v1, v4, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->putAscii([BILjava/lang/String;)V

    .line 84
    const/16 v2, 0xc

    const-string v5, "fmt "

    invoke-static {v1, v2, v5}, Lio/mesalabs/unica/settings/callai/Pcm;->putAscii([BILjava/lang/String;)V

    .line 85
    const/16 v2, 0x10

    invoke-static {v1, v2, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->putInt([BII)V

    .line 86
    const/16 v5, 0x14

    const/4 v6, 0x1

    invoke-static {v1, v5, v6}, Lio/mesalabs/unica/settings/callai/Pcm;->putShort([BII)V

    .line 87
    const/16 v5, 0x16

    invoke-static {v1, v5, v6}, Lio/mesalabs/unica/settings/callai/Pcm;->putShort([BII)V

    .line 88
    const/16 v5, 0x18

    invoke-static {v1, v5, p2}, Lio/mesalabs/unica/settings/callai/Pcm;->putInt([BII)V

    .line 89
    const/16 v5, 0x1c

    const/4 v7, 0x2

    mul-int/2addr p2, v7

    invoke-static {v1, v5, p2}, Lio/mesalabs/unica/settings/callai/Pcm;->putInt([BII)V

    .line 90
    const/16 p2, 0x20

    invoke-static {v1, p2, v7}, Lio/mesalabs/unica/settings/callai/Pcm;->putShort([BII)V

    .line 91
    const/16 p2, 0x22

    invoke-static {v1, p2, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->putShort([BII)V

    .line 92
    const-string p2, "data"

    const/16 v2, 0x24

    invoke-static {v1, v2, p2}, Lio/mesalabs/unica/settings/callai/Pcm;->putAscii([BILjava/lang/String;)V

    .line 93
    const/16 p2, 0x28

    invoke-static {v1, p2, v0}, Lio/mesalabs/unica/settings/callai/Pcm;->putInt([BII)V

    .line 94
    nop

    :goto_53
    if-ge v3, p1, :cond_6c

    .line 95
    mul-int/lit8 p2, v3, 0x2

    add-int/lit8 p2, p2, 0x2c

    aget-short v0, p0, v3

    and-int/lit16 v0, v0, 0xff

    int-to-byte v0, v0

    aput-byte v0, v1, p2

    .line 96
    add-int/2addr p2, v6

    aget-short v0, p0, v3

    shr-int/2addr v0, v4

    and-int/lit16 v0, v0, 0xff

    int-to-byte v0, v0

    aput-byte v0, v1, p2

    .line 94
    add-int/lit8 v3, v3, 0x1

    goto :goto_53

    .line 98
    :cond_6c
    return-object v1
.end method
