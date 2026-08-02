.class public final Lio/mesalabs/unica/settings/callai/CallRecorder;
.super Ljava/lang/Object;
.source "CallRecorder.java"


# static fields
.field static final DIR:Ljava/lang/String; = "callai"

.field static final INDEX:Ljava/lang/String; = "index.json"

.field private static final LOCK:Ljava/lang/Object;

.field private static final MAX_ENTRIES:I = 0x32

.field private static final QUEUE_MAX:I = 0x75300

.field static final RATE:I = 0x3e80

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"

.field private static sCount:I

.field private static sDir:Ljava/io/File;

.field private static sFile:Ljava/io/File;

.field private static sHead:I

.field private static sNumber:Ljava/lang/String;

.field private static sOut:Ljava/io/OutputStream;

.field private static sQueue:[S

.field private static sRole:Ljava/lang/String;

.field private static sSamples:I

.field private static sScratch:[B

.field private static sStarted:J

.field private static sTranscript:Ljava/lang/StringBuilder;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 36
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    return-void
.end method

.method private static addEntry(Ljava/io/File;Ljava/io/File;Ljava/lang/String;JJLjava/lang/String;)V
    .registers 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 304
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->readIndex(Ljava/io/File;)Lorg/json/JSONArray;

    move-result-object v0

    .line 305
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 306
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v2, "file"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 307
    const-string p1, "number"

    invoke-virtual {v1, p1, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 308
    const-string p1, "startedAt"

    invoke-virtual {v1, p1, p3, p4}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 309
    const-string p1, "durationMs"

    invoke-virtual {v1, p1, p5, p6}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 310
    const-string p1, "transcript"

    invoke-virtual {v1, p1, p7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 311
    const-string p1, "summary"

    const-string p2, ""

    invoke-virtual {v1, p1, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 312
    new-instance p1, Lorg/json/JSONArray;

    invoke-direct {p1}, Lorg/json/JSONArray;-><init>()V

    .line 313
    invoke-virtual {p1, v1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 314
    const/4 p3, 0x0

    :goto_36
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result p4

    if-ge p3, p4, :cond_4e

    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result p4

    const/16 p5, 0x32

    if-ge p4, p5, :cond_4e

    .line 315
    invoke-virtual {v0, p3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p4

    invoke-virtual {p1, p4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 314
    add-int/lit8 p3, p3, 0x1

    goto :goto_36

    .line 318
    :cond_4e
    const/16 p3, 0x31

    :goto_50
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result p4

    if-ge p3, p4, :cond_69

    .line 319
    new-instance p4, Ljava/io/File;

    invoke-virtual {v0, p3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p5

    invoke-virtual {p5, v2, p2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p5

    invoke-direct {p4, p0, p5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p4}, Ljava/io/File;->delete()Z

    .line 318
    add-int/lit8 p3, p3, 0x1

    goto :goto_50

    .line 321
    :cond_69
    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/callai/CallRecorder;->writeIndex(Ljava/io/File;Lorg/json/JSONArray;)V

    .line 322
    return-void
.end method

.method public static ai([SI)V
    .registers 7

    .line 127
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 128
    :try_start_3
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    if-eqz v1, :cond_36

    if-gtz p1, :cond_a

    goto :goto_36

    .line 131
    :cond_a
    sget v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    const/4 v2, 0x0

    if-lez v1, :cond_1f

    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    sget v3, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    sget v4, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    add-int/2addr v3, v4

    add-int/lit8 v3, v3, -0x1

    sget-object v4, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    array-length v4, v4

    rem-int/2addr v3, v4

    aget-short v1, v1, v3

    goto :goto_20

    :cond_1f
    move v1, v2

    .line 132
    :goto_20
    nop

    :goto_21
    if-ge v2, p1, :cond_34

    .line 133
    aget-short v3, p0, v2

    .line 134
    add-int/2addr v1, v3

    div-int/lit8 v1, v1, 0x2

    int-to-short v1, v1

    invoke-static {v1}, Lio/mesalabs/unica/settings/callai/CallRecorder;->push(S)V

    .line 135
    invoke-static {v3}, Lio/mesalabs/unica/settings/callai/CallRecorder;->push(S)V

    .line 136
    nop

    .line 132
    add-int/lit8 v2, v2, 0x1

    move v1, v3

    goto :goto_21

    .line 138
    :cond_34
    monitor-exit v0

    .line 139
    return-void

    .line 129
    :cond_36
    :goto_36
    monitor-exit v0

    return-void

    .line 138
    :catchall_38
    move-exception p0

    monitor-exit v0
    :try_end_3a
    .catchall {:try_start_3 .. :try_end_3a} :catchall_38

    throw p0
.end method

.method private static append(Ljava/lang/String;Lorg/json/JSONObject;)V
    .registers 4

    .line 179
    if-nez p1, :cond_3

    .line 180
    return-void

    .line 182
    :cond_3
    const-string v0, "text"

    const-string v1, ""

    invoke-virtual {p1, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/callai/CallRecorder;->note(Ljava/lang/String;Ljava/lang/String;)V

    .line 183
    return-void
.end method

.method private static ascii([BILjava/lang/String;)V
    .registers 5

    .line 257
    sget-object v0, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-virtual {p2, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p2

    .line 258
    const/4 v0, 0x0

    array-length v1, p2

    invoke-static {p2, v0, p0, p1, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 259
    return-void
.end method

.method public static caller([SI)V
    .registers 10

    .line 93
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 94
    :try_start_3
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;
    :try_end_5
    .catchall {:try_start_3 .. :try_end_5} :catchall_8a

    if-eqz v1, :cond_88

    if-gtz p1, :cond_b

    goto/16 :goto_88

    .line 98
    :cond_b
    :try_start_b
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    array-length v1, v1

    mul-int/lit8 v2, p1, 0x2

    if-ge v1, v2, :cond_16

    .line 99
    new-array v1, v2, [B

    sput-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    .line 101
    :cond_16
    const/4 v1, 0x0

    move v3, v1

    :goto_18
    if-ge v3, p1, :cond_59

    .line 102
    aget-short v4, p0, v3

    .line 103
    sget v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    if-lez v5, :cond_37

    .line 104
    sget-object v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    sget v6, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    aget-short v5, v5, v6

    add-int/2addr v4, v5

    .line 105
    sget v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    add-int/lit8 v5, v5, 0x1

    sget-object v6, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    array-length v6, v6

    rem-int/2addr v5, v6

    sput v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    .line 106
    sget v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    add-int/lit8 v5, v5, -0x1

    sput v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    .line 108
    :cond_37
    const/16 v5, 0x7fff

    if-le v4, v5, :cond_3d

    .line 109
    move v4, v5

    goto :goto_42

    .line 110
    :cond_3d
    const/16 v5, -0x8000

    if-ge v4, v5, :cond_42

    .line 111
    move v4, v5

    .line 113
    :cond_42
    :goto_42
    sget-object v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    mul-int/lit8 v6, v3, 0x2

    and-int/lit16 v7, v4, 0xff

    int-to-byte v7, v7

    aput-byte v7, v5, v6

    .line 114
    sget-object v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    add-int/lit8 v6, v6, 0x1

    shr-int/lit8 v4, v4, 0x8

    and-int/lit16 v4, v4, 0xff

    int-to-byte v4, v4

    aput-byte v4, v5, v6

    .line 101
    add-int/lit8 v3, v3, 0x1

    goto :goto_18

    .line 116
    :cond_59
    sget-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    sget-object v3, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    invoke-virtual {p0, v3, v1, v2}, Ljava/io/OutputStream;->write([BII)V

    .line 117
    sget p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sSamples:I

    add-int/2addr p0, p1

    sput p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sSamples:I
    :try_end_65
    .catch Ljava/lang/Exception; {:try_start_b .. :try_end_65} :catch_66
    .catchall {:try_start_b .. :try_end_65} :catchall_8a

    .line 121
    goto :goto_86

    .line 118
    :catch_66
    move-exception p0

    .line 119
    :try_start_67
    const-string p1, "UnicaCallAi"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "recorder write failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 120
    const/4 p0, 0x0

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    .line 122
    :goto_86
    monitor-exit v0

    .line 123
    return-void

    .line 95
    :cond_88
    :goto_88
    monitor-exit v0

    return-void

    .line 122
    :catchall_8a
    move-exception p0

    monitor-exit v0
    :try_end_8c
    .catchall {:try_start_67 .. :try_end_8c} :catchall_8a

    throw p0
.end method

.method private static close()V
    .registers 1

    .line 218
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    if-eqz v0, :cond_10

    .line 220
    :try_start_4
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    invoke-virtual {v0}, Ljava/io/OutputStream;->flush()V

    .line 221
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    invoke-virtual {v0}, Ljava/io/OutputStream;->close()V
    :try_end_e
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_e} :catch_f

    .line 223
    goto :goto_10

    .line 222
    :catch_f
    move-exception v0

    .line 225
    :cond_10
    :goto_10
    const/4 v0, 0x0

    sput-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    .line 226
    sput-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    .line 227
    sput-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    .line 228
    sput-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    .line 229
    return-void
.end method

.method static dir(Landroid/content/Context;)Ljava/io/File;
    .registers 3

    .line 55
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    const-string v1, "callai"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 56
    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result p0

    if-nez p0, :cond_14

    .line 57
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    .line 59
    :cond_14
    return-object v0
.end method

.method static index(Landroid/content/Context;)Ljava/io/File;
    .registers 3

    .line 63
    new-instance v0, Ljava/io/File;

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    const-string v1, "index.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method private static le16([BII)V
    .registers 4

    .line 269
    and-int/lit16 v0, p2, 0xff

    int-to-byte v0, v0

    aput-byte v0, p0, p1

    .line 270
    add-int/lit8 p1, p1, 0x1

    shr-int/lit8 p2, p2, 0x8

    and-int/lit16 p2, p2, 0xff

    int-to-byte p2, p2

    aput-byte p2, p0, p1

    .line 271
    return-void
.end method

.method private static le32([BII)V
    .registers 5

    .line 262
    and-int/lit16 v0, p2, 0xff

    int-to-byte v0, v0

    aput-byte v0, p0, p1

    .line 263
    add-int/lit8 v0, p1, 0x1

    shr-int/lit8 v1, p2, 0x8

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 264
    add-int/lit8 v0, p1, 0x2

    shr-int/lit8 v1, p2, 0x10

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 265
    add-int/lit8 p1, p1, 0x3

    shr-int/lit8 p2, p2, 0x18

    and-int/lit16 p2, p2, 0xff

    int-to-byte p2, p2

    aput-byte p2, p0, p1

    .line 266
    return-void
.end method

.method public static note(Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    .line 160
    if-eqz p1, :cond_40

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_40

    .line 163
    :cond_9
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 164
    :try_start_c
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    if-nez v1, :cond_12

    .line 165
    monitor-exit v0

    return-void

    .line 167
    :cond_12
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sRole:Ljava/lang/String;

    invoke-virtual {p0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_36

    .line 168
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    if-lez v1, :cond_29

    .line 169
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 171
    :cond_29
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ": "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 172
    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sRole:Ljava/lang/String;

    .line 174
    :cond_36
    sget-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 175
    monitor-exit v0

    .line 176
    return-void

    .line 175
    :catchall_3d
    move-exception p0

    monitor-exit v0
    :try_end_3f
    .catchall {:try_start_c .. :try_end_3f} :catchall_3d

    throw p0

    .line 161
    :cond_40
    :goto_40
    return-void
.end method

.method private static patchHeader(Ljava/io/File;I)V
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 232
    const/4 v0, 0x2

    mul-int/2addr p1, v0

    .line 233
    const/16 v1, 0x2c

    new-array v1, v1, [B

    .line 234
    const/4 v2, 0x0

    const-string v3, "RIFF"

    invoke-static {v1, v2, v3}, Lio/mesalabs/unica/settings/callai/CallRecorder;->ascii([BILjava/lang/String;)V

    .line 235
    add-int/lit8 v2, p1, 0x24

    const/4 v3, 0x4

    invoke-static {v1, v3, v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le32([BII)V

    .line 236
    const/16 v2, 0x8

    const-string v3, "WAVE"

    invoke-static {v1, v2, v3}, Lio/mesalabs/unica/settings/callai/CallRecorder;->ascii([BILjava/lang/String;)V

    .line 237
    const/16 v2, 0xc

    const-string v3, "fmt "

    invoke-static {v1, v2, v3}, Lio/mesalabs/unica/settings/callai/CallRecorder;->ascii([BILjava/lang/String;)V

    .line 238
    const/16 v2, 0x10

    invoke-static {v1, v2, v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le32([BII)V

    .line 239
    const/16 v3, 0x14

    const/4 v4, 0x1

    invoke-static {v1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le16([BII)V

    .line 240
    const/16 v3, 0x16

    invoke-static {v1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le16([BII)V

    .line 241
    const/16 v3, 0x18

    const/16 v4, 0x3e80

    invoke-static {v1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le32([BII)V

    .line 242
    const/16 v3, 0x1c

    const/16 v4, 0x7d00

    invoke-static {v1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le32([BII)V

    .line 243
    const/16 v3, 0x20

    invoke-static {v1, v3, v0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le16([BII)V

    .line 244
    const/16 v0, 0x22

    invoke-static {v1, v0, v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le16([BII)V

    .line 245
    const-string v0, "data"

    const/16 v2, 0x24

    invoke-static {v1, v2, v0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->ascii([BILjava/lang/String;)V

    .line 246
    const/16 v0, 0x28

    invoke-static {v1, v0, p1}, Lio/mesalabs/unica/settings/callai/CallRecorder;->le32([BII)V

    .line 247
    new-instance p1, Ljava/io/RandomAccessFile;

    const-string v0, "rw"

    invoke-direct {p1, p0, v0}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 249
    const-wide/16 v2, 0x0

    :try_start_5d
    invoke-virtual {p1, v2, v3}, Ljava/io/RandomAccessFile;->seek(J)V

    .line 250
    invoke-virtual {p1, v1}, Ljava/io/RandomAccessFile;->write([B)V
    :try_end_63
    .catchall {:try_start_5d .. :try_end_63} :catchall_68

    .line 252
    invoke-virtual {p1}, Ljava/io/RandomAccessFile;->close()V

    .line 253
    nop

    .line 254
    return-void

    .line 252
    :catchall_68
    move-exception p0

    invoke-virtual {p1}, Ljava/io/RandomAccessFile;->close()V

    .line 253
    throw p0
.end method

.method private static push(S)V
    .registers 4

    .line 142
    sget v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    array-length v1, v1

    if-ne v0, v1, :cond_17

    .line 143
    sget v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    add-int/lit8 v0, v0, 0x1

    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    array-length v1, v1

    rem-int/2addr v0, v1

    sput v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    .line 144
    sget v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    add-int/lit8 v0, v0, -0x1

    sput v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    .line 146
    :cond_17
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    sget v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    sget v2, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    add-int/2addr v1, v2

    sget-object v2, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    array-length v2, v2

    rem-int/2addr v1, v2

    aput-short p0, v0, v1

    .line 147
    sget p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    add-int/lit8 p0, p0, 0x1

    sput p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    .line 148
    return-void
.end method

.method static readIndex(Ljava/io/File;)Lorg/json/JSONArray;
    .registers 4

    .line 274
    new-instance v0, Ljava/io/File;

    const-string v1, "index.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 275
    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result p0

    if-nez p0, :cond_13

    .line 276
    new-instance p0, Lorg/json/JSONArray;

    invoke-direct {p0}, Lorg/json/JSONArray;-><init>()V

    return-object p0

    .line 279
    :cond_13
    :try_start_13
    new-instance p0, Ljava/io/RandomAccessFile;

    const-string v1, "r"

    invoke-direct {p0, v0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 280
    invoke-virtual {p0}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v0

    long-to-int v0, v0

    new-array v0, v0, [B
    :try_end_21
    .catch Ljava/lang/Exception; {:try_start_13 .. :try_end_21} :catch_3a

    .line 282
    :try_start_21
    invoke-virtual {p0, v0}, Ljava/io/RandomAccessFile;->readFully([B)V
    :try_end_24
    .catchall {:try_start_21 .. :try_end_24} :catchall_35

    .line 284
    :try_start_24
    invoke-virtual {p0}, Ljava/io/RandomAccessFile;->close()V

    .line 285
    nop

    .line 286
    new-instance p0, Lorg/json/JSONArray;

    new-instance v1, Ljava/lang/String;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {p0, v1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    return-object p0

    .line 284
    :catchall_35
    move-exception v0

    invoke-virtual {p0}, Ljava/io/RandomAccessFile;->close()V

    .line 285
    throw v0
    :try_end_3a
    .catch Ljava/lang/Exception; {:try_start_24 .. :try_end_3a} :catch_3a

    .line 287
    :catch_3a
    move-exception p0

    .line 288
    new-instance p0, Lorg/json/JSONArray;

    invoke-direct {p0}, Lorg/json/JSONArray;-><init>()V

    return-object p0
.end method

.method public static start(Landroid/content/Context;Ljava/lang/String;)V
    .registers 7

    .line 67
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 68
    :try_start_3
    invoke-static {}, Lio/mesalabs/unica/settings/callai/CallRecorder;->close()V
    :try_end_6
    .catchall {:try_start_3 .. :try_end_6} :catchall_b1

    .line 70
    :try_start_6
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object p0

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sDir:Ljava/io/File;

    .line 71
    new-instance p0, Ljava/io/File;

    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sDir:Ljava/io/File;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".wav"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sFile:Ljava/io/File;

    .line 72
    new-instance p0, Ljava/io/BufferedOutputStream;

    new-instance v1, Ljava/io/FileOutputStream;

    sget-object v2, Lio/mesalabs/unica/settings/callai/CallRecorder;->sFile:Ljava/io/File;

    invoke-direct {v1, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const/16 v2, 0x4000

    invoke-direct {p0, v1, v2}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;I)V

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    .line 73
    sget-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    const/16 v1, 0x2c

    new-array v1, v1, [B

    invoke-virtual {p0, v1}, Ljava/io/OutputStream;->write([B)V

    .line 74
    if-nez p1, :cond_49

    const-string p1, ""

    :cond_49
    sput-object p1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sNumber:Ljava/lang/String;

    .line 75
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    sput-wide p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sStarted:J

    .line 76
    const/4 p0, 0x0

    sput p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sSamples:I

    .line 77
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    sput-object p1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    .line 78
    const-string p1, ""

    sput-object p1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sRole:Ljava/lang/String;

    .line 79
    const p1, 0x75300

    new-array p1, p1, [S

    sput-object p1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sQueue:[S

    .line 80
    sput p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sHead:I

    .line 81
    sput p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sCount:I

    .line 82
    const/16 p0, 0x2000

    new-array p0, p0, [B

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sScratch:[B

    .line 83
    const-string p0, "UnicaCallAi"

    sget-object p1, Lio/mesalabs/unica/settings/callai/CallRecorder;->sFile:Ljava/io/File;

    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "recording call to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_8e
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_8e} :catch_8f
    .catchall {:try_start_6 .. :try_end_8e} :catchall_b1

    .line 87
    goto :goto_af

    .line 84
    :catch_8f
    move-exception p0

    .line 85
    :try_start_90
    const-string p1, "UnicaCallAi"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "recorder start failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 86
    const/4 p0, 0x0

    sput-object p0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    .line 88
    :goto_af
    monitor-exit v0

    .line 89
    return-void

    .line 88
    :catchall_b1
    move-exception p0

    monitor-exit v0
    :try_end_b3
    .catchall {:try_start_90 .. :try_end_b3} :catchall_b1

    throw p0
.end method

.method public static stop()V
    .registers 14

    .line 186
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallRecorder;->LOCK:Ljava/lang/Object;

    monitor-enter v1

    .line 187
    :try_start_3
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sOut:Ljava/io/OutputStream;

    if-nez v0, :cond_c

    .line 188
    invoke-static {}, Lio/mesalabs/unica/settings/callai/CallRecorder;->close()V

    .line 189
    monitor-exit v1

    return-void

    .line 191
    :cond_c
    sget-object v3, Lio/mesalabs/unica/settings/callai/CallRecorder;->sFile:Ljava/io/File;

    .line 192
    sget v10, Lio/mesalabs/unica/settings/callai/CallRecorder;->sSamples:I

    .line 193
    sget-object v4, Lio/mesalabs/unica/settings/callai/CallRecorder;->sNumber:Ljava/lang/String;

    .line 194
    sget-wide v5, Lio/mesalabs/unica/settings/callai/CallRecorder;->sStarted:J

    .line 195
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    if-nez v0, :cond_1b

    const-string v0, ""

    goto :goto_21

    :cond_1b
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallRecorder;->sTranscript:Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_21
    move-object v9, v0

    .line 196
    sget-object v2, Lio/mesalabs/unica/settings/callai/CallRecorder;->sDir:Ljava/io/File;

    .line 197
    invoke-static {}, Lio/mesalabs/unica/settings/callai/CallRecorder;->close()V
    :try_end_27
    .catchall {:try_start_3 .. :try_end_27} :catchall_a2

    .line 199
    :try_start_27
    invoke-static {v3, v10}, Lio/mesalabs/unica/settings/callai/CallRecorder;->patchHeader(Ljava/io/File;I)V
    :try_end_2a
    .catch Ljava/lang/Exception; {:try_start_27 .. :try_end_2a} :catch_2b
    .catchall {:try_start_27 .. :try_end_2a} :catchall_a2

    .line 202
    goto :goto_48

    .line 200
    :catch_2b
    move-exception v0

    .line 201
    :try_start_2c
    const-string v7, "UnicaCallAi"

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "wav header patch failed: "

    invoke-virtual {v8, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 203
    :goto_48
    const/16 v11, 0x3e80

    if-ge v10, v11, :cond_51

    .line 205
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    .line 206
    monitor-exit v1
    :try_end_50
    .catchall {:try_start_2c .. :try_end_50} :catchall_a2

    return-void

    .line 209
    :cond_51
    int-to-long v7, v10

    const-wide/16 v12, 0x3e8

    mul-long/2addr v7, v12

    const-wide/16 v12, 0x3e80

    :try_start_57
    div-long/2addr v7, v12

    invoke-static/range {v2 .. v9}, Lio/mesalabs/unica/settings/callai/CallRecorder;->addEntry(Ljava/io/File;Ljava/io/File;Ljava/lang/String;JJLjava/lang/String;)V
    :try_end_5b
    .catch Ljava/lang/Exception; {:try_start_57 .. :try_end_5b} :catch_5c
    .catchall {:try_start_57 .. :try_end_5b} :catchall_a2

    .line 212
    goto :goto_79

    .line 210
    :catch_5c
    move-exception v0

    .line 211
    :try_start_5d
    const-string v2, "UnicaCallAi"

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "call log write failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 213
    :goto_79
    const-string v0, "UnicaCallAi"

    div-int/2addr v10, v11

    invoke-virtual {v3}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "recorded "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "s to "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 214
    monitor-exit v1

    .line 215
    return-void

    .line 214
    :catchall_a2
    move-exception v0

    monitor-exit v1
    :try_end_a4
    .catchall {:try_start_5d .. :try_end_a4} :catchall_a2

    throw v0
.end method

.method public static transcript(Lorg/json/JSONObject;)V
    .registers 3

    .line 152
    if-nez p0, :cond_3

    .line 153
    return-void

    .line 155
    :cond_3
    const-string v0, "inputTranscription"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "caller"

    invoke-static {v1, v0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->append(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 156
    const-string v0, "outputTranscription"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    const-string v0, "ai"

    invoke-static {v0, p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->append(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 157
    return-void
.end method

.method static writeIndex(Ljava/io/File;Lorg/json/JSONArray;)V
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 293
    new-instance v0, Ljava/io/File;

    const-string v1, "index.json"

    invoke-direct {v0, p0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 294
    new-instance p0, Ljava/io/FileOutputStream;

    invoke-direct {p0, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 296
    :try_start_c
    invoke-virtual {p1}, Lorg/json/JSONArray;->toString()Ljava/lang/String;

    move-result-object p1

    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_19
    .catchall {:try_start_c .. :try_end_19} :catchall_1e

    .line 298
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V

    .line 299
    nop

    .line 300
    return-void

    .line 298
    :catchall_1e
    move-exception p1

    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V

    .line 299
    throw p1
.end method
