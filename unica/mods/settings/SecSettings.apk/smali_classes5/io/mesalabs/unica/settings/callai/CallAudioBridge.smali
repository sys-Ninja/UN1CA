.class final Lio/mesalabs/unica/settings/callai/CallAudioBridge;
.super Ljava/lang/Object;
.source "CallAudioBridge.java"


# static fields
.field static final DOWNLINK_RATE:I = 0x3e80

.field private static final SOCK_DOWNLINK:Ljava/lang/String; = "unica_ca_dl"

.field private static final SOCK_UPLINK:Ljava/lang/String; = "unica_ca_ul"

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"

.field static final UPLINK_RATE:I = 0x1f40


# instance fields
.field private mDownlink:Landroid/net/LocalSocket;

.field private mIn:Ljava/io/InputStream;

.field private mOut:Ljava/io/OutputStream;

.field private mUplink:Landroid/net/LocalSocket;


# direct methods
.method constructor <init>()V
    .registers 1

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static closeQuietly(Landroid/net/LocalSocket;)V
    .registers 1

    .line 126
    if-eqz p0, :cond_7

    .line 128
    :try_start_2
    invoke-virtual {p0}, Landroid/net/LocalSocket;->close()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_5} :catch_6

    .line 131
    goto :goto_7

    .line 129
    :catch_6
    move-exception p0

    .line 133
    :cond_7
    :goto_7
    return-void
.end method

.method private static open(Ljava/lang/String;)Landroid/net/LocalSocket;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 64
    new-instance v0, Landroid/net/LocalSocket;

    invoke-direct {v0}, Landroid/net/LocalSocket;-><init>()V

    .line 65
    new-instance v1, Landroid/net/LocalSocketAddress;

    sget-object v2, Landroid/net/LocalSocketAddress$Namespace;->ABSTRACT:Landroid/net/LocalSocketAddress$Namespace;

    invoke-direct {v1, p0, v2}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;Landroid/net/LocalSocketAddress$Namespace;)V

    invoke-virtual {v0, v1}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    .line 66
    return-object v0
.end method


# virtual methods
.method close()V
    .registers 2

    .line 117
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mDownlink:Landroid/net/LocalSocket;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->closeQuietly(Landroid/net/LocalSocket;)V

    .line 118
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mUplink:Landroid/net/LocalSocket;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->closeQuietly(Landroid/net/LocalSocket;)V

    .line 119
    const/4 v0, 0x0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mDownlink:Landroid/net/LocalSocket;

    .line 120
    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mUplink:Landroid/net/LocalSocket;

    .line 121
    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mIn:Ljava/io/InputStream;

    .line 122
    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    .line 123
    return-void
.end method

.method connect(J)Z
    .registers 7

    .line 40
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    add-long/2addr v0, p1

    .line 41
    :goto_5
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    cmp-long p1, p1, v0

    const/4 p2, 0x0

    const-string v2, "UnicaCallAi"

    if-gez p1, :cond_4b

    .line 43
    :try_start_10
    const-string p1, "unica_ca_dl"

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->open(Ljava/lang/String;)Landroid/net/LocalSocket;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mDownlink:Landroid/net/LocalSocket;

    .line 44
    const-string p1, "unica_ca_ul"

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->open(Ljava/lang/String;)Landroid/net/LocalSocket;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mUplink:Landroid/net/LocalSocket;

    .line 45
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mDownlink:Landroid/net/LocalSocket;

    invoke-virtual {p1}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mIn:Ljava/io/InputStream;

    .line 46
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mUplink:Landroid/net/LocalSocket;

    invoke-virtual {p1}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    .line 47
    const-string p1, "bridge connected"

    invoke-static {v2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_35
    .catch Ljava/lang/Exception; {:try_start_10 .. :try_end_35} :catch_37

    .line 48
    const/4 p1, 0x1

    return p1

    .line 49
    :catch_37
    move-exception p1

    .line 50
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->close()V

    .line 52
    const-wide/16 v2, 0xfa

    :try_start_3d
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_40
    .catch Ljava/lang/InterruptedException; {:try_start_3d .. :try_end_40} :catch_42

    .line 56
    nop

    .line 57
    goto :goto_5

    .line 53
    :catch_42
    move-exception p1

    .line 54
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 55
    return p2

    .line 59
    :cond_4b
    const-string p1, "bridge could not reach ca_daemon"

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 60
    return p2
.end method

.method isConnected()Z
    .registers 2

    .line 70
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mIn:Ljava/io/InputStream;

    if-eqz v0, :cond_a

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    if-eqz v0, :cond_a

    const/4 v0, 0x1

    goto :goto_b

    :cond_a
    const/4 v0, 0x0

    :goto_b
    return v0
.end method

.method readDownlink([SI)I
    .registers 10

    .line 75
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mIn:Ljava/io/InputStream;

    const/4 v1, -0x1

    if-nez v0, :cond_6

    .line 76
    return v1

    .line 78
    :cond_6
    mul-int/lit8 v0, p2, 0x2

    new-array v2, v0, [B

    .line 79
    const/4 v3, 0x0

    move v4, v3

    .line 81
    :goto_c
    if-ge v4, v0, :cond_1d

    .line 82
    :try_start_e
    iget-object v5, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mIn:Ljava/io/InputStream;

    sub-int v6, v0, v4

    invoke-virtual {v5, v2, v4, v6}, Ljava/io/InputStream;->read([BII)I

    move-result v5
    :try_end_16
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_16} :catch_1b

    .line 83
    if-gez v5, :cond_19

    .line 84
    return v1

    .line 86
    :cond_19
    add-int/2addr v4, v5

    .line 87
    goto :goto_c

    .line 88
    :catch_1b
    move-exception p1

    .line 89
    return v1

    .line 90
    :cond_1d
    nop

    .line 91
    nop

    :goto_1f
    if-ge v3, p2, :cond_34

    .line 92
    mul-int/lit8 v0, v3, 0x2

    aget-byte v1, v2, v0

    and-int/lit16 v1, v1, 0xff

    add-int/lit8 v0, v0, 0x1

    aget-byte v0, v2, v0

    shl-int/lit8 v0, v0, 0x8

    or-int/2addr v0, v1

    int-to-short v0, v0

    aput-short v0, p1, v3

    .line 91
    add-int/lit8 v3, v3, 0x1

    goto :goto_1f

    .line 94
    :cond_34
    invoke-static {p1, p2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->caller([SI)V

    return p2
.end method

.method writeUplink([SI)V
    .registers 7

    .line 99
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    if-nez v0, :cond_5

    .line 100
    return-void

    .line 102
    :cond_5
    invoke-static {p1, p2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->ai([SI)V

    mul-int/lit8 v0, p2, 0x2

    new-array v0, v0, [B

    .line 103
    const/4 v1, 0x0

    :goto_a
    if-ge v1, p2, :cond_23

    .line 104
    mul-int/lit8 v2, v1, 0x2

    aget-short v3, p1, v1

    and-int/lit16 v3, v3, 0xff

    int-to-byte v3, v3

    aput-byte v3, v0, v2

    .line 105
    add-int/lit8 v2, v2, 0x1

    aget-short v3, p1, v1

    shr-int/lit8 v3, v3, 0x8

    and-int/lit16 v3, v3, 0xff

    int-to-byte v3, v3

    aput-byte v3, v0, v2

    .line 103
    add-int/lit8 v1, v1, 0x1

    goto :goto_a

    .line 108
    :cond_23
    :try_start_23
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    invoke-virtual {p1, v0}, Ljava/io/OutputStream;->write([B)V

    .line 109
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    invoke-virtual {p1}, Ljava/io/OutputStream;->flush()V
    :try_end_2d
    .catch Ljava/lang/Exception; {:try_start_23 .. :try_end_2d} :catch_2e

    .line 113
    goto :goto_4e

    .line 110
    :catch_2e
    move-exception p1

    .line 111
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "uplink write failed: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "UnicaCallAi"

    invoke-static {p2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 112
    const/4 p1, 0x0

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->mOut:Ljava/io/OutputStream;

    .line 114
    :goto_4e
    return-void
.end method
