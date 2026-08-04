.class final Lio/mesalabs/unica/settings/callai/WebSocketClient;
.super Ljava/lang/Object;
.source "WebSocketClient.java"


# static fields
.field private static final GUID:Ljava/lang/String; = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

.field private static final OP_BINARY:I = 0x2

.field private static final OP_CLOSE:I = 0x8

.field private static final OP_CONTINUATION:I = 0x0

.field private static final OP_PING:I = 0x9

.field private static final OP_PONG:I = 0xa

.field private static final OP_TEXT:I = 0x1


# instance fields
.field private mIn:Ljava/io/InputStream;

.field private mOut:Ljava/io/OutputStream;

.field private final mRandom:Ljava/security/SecureRandom;

.field private mSocket:Ljava/net/Socket;

.field private final mWriteLock:Ljava/lang/Object;


# direct methods
.method constructor <init>()V
    .registers 2

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    new-instance v0, Ljava/security/SecureRandom;

    invoke-direct {v0}, Ljava/security/SecureRandom;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mRandom:Ljava/security/SecureRandom;

    .line 43
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mWriteLock:Ljava/lang/Object;

    return-void
.end method

.method private static expectedAccept(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 100
    :try_start_0
    const-string v0, "SHA-1"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 101
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sget-object v1, Ljava/nio/charset/StandardCharsets;->ISO_8859_1:Ljava/nio/charset/Charset;

    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object p0

    .line 102
    const/4 v0, 0x2

    invoke-static {p0, v0}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0
    :try_end_28
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_28} :catch_29

    return-object p0

    .line 103
    :catch_29
    move-exception p0

    .line 104
    const-string p0, ""

    return-object p0
.end method

.method private static readByte(Ljava/io/InputStream;)I
    .registers 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 247
    invoke-virtual {p0}, Ljava/io/InputStream;->read()I

    move-result p0

    .line 248
    if-ltz p0, :cond_7

    .line 251
    return p0

    .line 249
    :cond_7
    new-instance p0, Ljava/io/EOFException;

    invoke-direct {p0}, Ljava/io/EOFException;-><init>()V

    throw p0
.end method

.method private static readFully(Ljava/io/InputStream;[BI)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 255
    const/4 v0, 0x0

    .line 256
    :goto_1
    if-ge v0, p2, :cond_13

    .line 257
    sub-int v1, p2, v0

    invoke-virtual {p0, p1, v0, v1}, Ljava/io/InputStream;->read([BII)I

    move-result v1

    .line 258
    if-ltz v1, :cond_d

    .line 261
    add-int/2addr v0, v1

    .line 262
    goto :goto_1

    .line 259
    :cond_d
    new-instance p0, Ljava/io/EOFException;

    invoke-direct {p0}, Ljava/io/EOFException;-><init>()V

    throw p0

    .line 263
    :cond_13
    return-void
.end method

.method private static readLine(Ljava/io/InputStream;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 109
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 111
    :goto_5
    invoke-virtual {p0}, Ljava/io/InputStream;->read()I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_2d

    .line 112
    const/16 v2, 0xa

    if-ne v1, v2, :cond_28

    .line 113
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    .line 114
    if-lez p0, :cond_23

    add-int/lit8 p0, p0, -0x1

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->charAt(I)C

    move-result v1

    const/16 v2, 0xd

    if-ne v1, v2, :cond_23

    .line 115
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->setLength(I)V

    .line 117
    :cond_23
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 119
    :cond_28
    int-to-char v1, v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_5

    .line 121
    :cond_2d
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    if-nez p0, :cond_35

    const/4 p0, 0x0

    goto :goto_39

    :cond_35
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :goto_39
    return-object p0
.end method

.method private sendFrame(I[B)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 129
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mWriteLock:Ljava/lang/Object;

    monitor-enter v0

    .line 130
    :try_start_3
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mOut:Ljava/io/OutputStream;

    .line 131
    if-eqz v1, :cond_66

    .line 134
    or-int/lit16 p1, p1, 0x80

    invoke-virtual {v1, p1}, Ljava/io/OutputStream;->write(I)V

    .line 136
    array-length p1, p2

    .line 137
    const/16 v2, 0x7e

    if-ge p1, v2, :cond_17

    .line 138
    or-int/lit16 v2, p1, 0x80

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write(I)V

    goto :goto_41

    .line 139
    :cond_17
    const/high16 v2, 0x10000

    const/16 v3, 0xff

    if-ge p1, v2, :cond_2e

    .line 140
    const/16 v2, 0xfe

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write(I)V

    .line 141
    ushr-int/lit8 v2, p1, 0x8

    and-int/2addr v2, v3

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write(I)V

    .line 142
    and-int/lit16 v2, p1, 0xff

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write(I)V

    goto :goto_41

    .line 144
    :cond_2e
    invoke-virtual {v1, v3}, Ljava/io/OutputStream;->write(I)V

    .line 145
    const/16 v2, 0x38

    :goto_33
    if-ltz v2, :cond_41

    .line 146
    int-to-long v3, p1

    ushr-long/2addr v3, v2

    const-wide/16 v5, 0xff

    and-long/2addr v3, v5

    long-to-int v3, v3

    invoke-virtual {v1, v3}, Ljava/io/OutputStream;->write(I)V

    .line 145
    add-int/lit8 v2, v2, -0x8

    goto :goto_33

    .line 151
    :cond_41
    :goto_41
    const/4 v2, 0x4

    new-array v2, v2, [B

    .line 152
    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mRandom:Ljava/security/SecureRandom;

    invoke-virtual {v3, v2}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 153
    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    .line 154
    new-array v3, p1, [B

    .line 155
    const/4 v4, 0x0

    :goto_4f
    if-ge v4, p1, :cond_5e

    .line 156
    aget-byte v5, p2, v4

    and-int/lit8 v6, v4, 0x3

    aget-byte v6, v2, v6

    xor-int/2addr v5, v6

    int-to-byte v5, v5

    aput-byte v5, v3, v4

    .line 155
    add-int/lit8 v4, v4, 0x1

    goto :goto_4f

    .line 158
    :cond_5e
    invoke-virtual {v1, v3}, Ljava/io/OutputStream;->write([B)V

    .line 159
    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V

    .line 160
    monitor-exit v0

    .line 161
    return-void

    .line 132
    :cond_66
    new-instance p1, Ljava/io/IOException;

    const-string p2, "closed"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 160
    :catchall_6e
    move-exception p1

    monitor-exit v0
    :try_end_70
    .catchall {:try_start_3 .. :try_end_70} :catchall_6e

    throw p1
.end method


# virtual methods
.method close()V
    .registers 3

    .line 267
    const/4 v0, 0x0

    :try_start_1
    new-array v0, v0, [B

    const/16 v1, 0x8

    invoke-direct {p0, v1, v0}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendFrame(I[B)V
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_8} :catch_9

    .line 270
    goto :goto_a

    .line 268
    :catch_9
    move-exception v0

    .line 271
    :goto_a
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mSocket:Ljava/net/Socket;

    .line 272
    const/4 v1, 0x0

    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mSocket:Ljava/net/Socket;

    .line 273
    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mIn:Ljava/io/InputStream;

    .line 274
    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mOut:Ljava/io/OutputStream;

    .line 275
    if-eqz v0, :cond_1a

    .line 277
    :try_start_15
    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_18
    .catch Ljava/lang/Exception; {:try_start_15 .. :try_end_18} :catch_19

    .line 280
    goto :goto_1a

    .line 278
    :catch_19
    move-exception v0

    .line 282
    :cond_1a
    :goto_1a
    return-void
.end method

.method connect(Ljava/lang/String;ILjava/lang/String;I)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 46
    invoke-static {}, Ljavax/net/ssl/SSLSocketFactory;->getDefault()Ljavax/net/SocketFactory;

    move-result-object v0

    invoke-virtual {v0}, Ljavax/net/SocketFactory;->createSocket()Ljava/net/Socket;

    move-result-object v0

    check-cast v0, Ljavax/net/ssl/SSLSocket;

    .line 47
    new-instance v1, Ljava/net/InetSocketAddress;

    invoke-direct {v1, p1, p2}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v0, v1, p4}, Ljavax/net/ssl/SSLSocket;->connect(Ljava/net/SocketAddress;I)V

    .line 48
    invoke-virtual {v0, p4}, Ljavax/net/ssl/SSLSocket;->setSoTimeout(I)V

    .line 49
    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->startHandshake()V

    .line 51
    const/16 p2, 0x10

    new-array p2, p2, [B

    .line 52
    iget-object p4, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mRandom:Ljava/security/SecureRandom;

    invoke-virtual {p4, p2}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 53
    const/4 p4, 0x2

    invoke-static {p2, p4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p2

    .line 55
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "GET "

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string p4, " HTTP/1.1\r\nHost: "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p3, "\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p3, "\r\nSec-WebSocket-Version: 13\r\n\r\n"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 62
    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p3

    .line 63
    sget-object p4, Ljava/nio/charset/StandardCharsets;->ISO_8859_1:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p4}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {p3, p1}, Ljava/io/OutputStream;->write([B)V

    .line 64
    invoke-virtual {p3}, Ljava/io/OutputStream;->flush()V

    .line 66
    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object p1

    .line 67
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readLine(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object p4

    .line 68
    if-eqz p4, :cond_c2

    const-string v1, " 101"

    invoke-virtual {p4, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_c2

    .line 72
    const/4 p4, 0x0

    .line 74
    :goto_76
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readLine(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_a6

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_a6

    .line 75
    const/16 v2, 0x3a

    invoke-virtual {v1, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    .line 76
    if-lez v2, :cond_a5

    const/4 v3, 0x0

    invoke-virtual {v1, v3, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 77
    const-string v4, "Sec-WebSocket-Accept"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_a5

    .line 78
    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p4

    .line 80
    :cond_a5
    goto :goto_76

    .line 81
    :cond_a6
    invoke-static {p2}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->expectedAccept(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p2, p4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_b7

    .line 86
    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mSocket:Ljava/net/Socket;

    .line 87
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mIn:Ljava/io/InputStream;

    .line 88
    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mOut:Ljava/io/OutputStream;

    .line 89
    return-void

    .line 82
    :cond_b7
    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->close()V

    .line 83
    new-instance p1, Ljava/io/IOException;

    const-string p2, "bad Sec-WebSocket-Accept"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 69
    :cond_c2
    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->close()V

    .line 70
    new-instance p1, Ljava/io/IOException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "upgrade refused: "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method receiveText()Ljava/lang/String;
    .registers 18
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 170
    move-object/from16 v0, p0

    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 171
    const/4 v3, -0x1

    .line 174
    :goto_8
    iget-object v4, v0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mIn:Ljava/io/InputStream;

    .line 175
    const/4 v5, 0x0

    if-nez v4, :cond_e

    .line 176
    return-object v5

    .line 178
    :cond_e
    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v6

    .line 179
    if-gez v6, :cond_15

    .line 180
    return-object v5

    .line 182
    :cond_15
    and-int/lit16 v7, v6, 0x80

    if-eqz v7, :cond_1b

    const/4 v7, 0x1

    goto :goto_1c

    :cond_1b
    const/4 v7, 0x0

    .line 183
    :goto_1c
    and-int/lit8 v6, v6, 0xf

    .line 185
    invoke-virtual {v4}, Ljava/io/InputStream;->read()I

    move-result v10

    .line 186
    if-gez v10, :cond_25

    .line 187
    return-object v5

    .line 189
    :cond_25
    and-int/lit16 v11, v10, 0x80

    if-eqz v11, :cond_2b

    const/4 v11, 0x1

    goto :goto_2c

    :cond_2b
    const/4 v11, 0x0

    .line 190
    :goto_2c
    and-int/lit8 v10, v10, 0x7f

    int-to-long v12, v10

    .line 191
    const-wide/16 v14, 0x7e

    cmp-long v10, v12, v14

    const/16 v14, 0x8

    if-nez v10, :cond_46

    .line 192
    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readByte(Ljava/io/InputStream;)I

    move-result v10

    int-to-long v12, v10

    shl-long/2addr v12, v14

    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readByte(Ljava/io/InputStream;)I

    move-result v10

    move/from16 v16, v3

    int-to-long v2, v10

    or-long/2addr v12, v2

    goto :goto_5f

    .line 193
    :cond_46
    move/from16 v16, v3

    const-wide/16 v2, 0x7f

    cmp-long v2, v12, v2

    if-nez v2, :cond_5f

    .line 194
    nop

    .line 195
    const-wide/16 v2, 0x0

    move-wide v12, v2

    const/4 v2, 0x0

    :goto_53
    if-ge v2, v14, :cond_5f

    .line 196
    shl-long/2addr v12, v14

    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readByte(Ljava/io/InputStream;)I

    move-result v3

    int-to-long v8, v3

    or-long/2addr v12, v8

    .line 195
    add-int/lit8 v2, v2, 0x1

    goto :goto_53

    .line 199
    :cond_5f
    :goto_5f
    const-wide/32 v2, 0x2000000

    cmp-long v2, v12, v2

    if-gtz v2, :cond_e6

    .line 203
    nop

    .line 204
    if-eqz v11, :cond_70

    .line 205
    const/4 v2, 0x4

    new-array v3, v2, [B

    .line 206
    invoke-static {v4, v3, v2}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readFully(Ljava/io/InputStream;[BI)V

    goto :goto_71

    .line 204
    :cond_70
    move-object v3, v5

    .line 208
    :goto_71
    long-to-int v2, v12

    new-array v8, v2, [B

    .line 209
    invoke-static {v4, v8, v2}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->readFully(Ljava/io/InputStream;[BI)V

    .line 210
    if-eqz v3, :cond_89

    .line 211
    const/4 v4, 0x0

    :goto_7a
    if-ge v4, v2, :cond_89

    .line 212
    aget-byte v9, v8, v4

    and-int/lit8 v11, v4, 0x3

    aget-byte v11, v3, v11

    xor-int/2addr v9, v11

    int-to-byte v9, v9

    aput-byte v9, v8, v4

    .line 211
    add-int/lit8 v4, v4, 0x1

    goto :goto_7a

    .line 216
    :cond_89
    const/16 v2, 0x9

    const/16 v3, 0xa

    if-ne v6, v2, :cond_93

    .line 217
    invoke-direct {v0, v3, v8}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendFrame(I[B)V

    .line 218
    goto :goto_96

    .line 220
    :cond_93
    if-ne v6, v3, :cond_9a

    .line 221
    nop

    .line 174
    :goto_96
    move/from16 v3, v16

    goto/16 :goto_8

    .line 223
    :cond_9a
    if-ne v6, v14, :cond_a5

    .line 225
    const/4 v1, 0x0

    :try_start_9d
    new-array v1, v1, [B

    invoke-direct {v0, v14, v1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendFrame(I[B)V
    :try_end_a2
    .catch Ljava/io/IOException; {:try_start_9d .. :try_end_a2} :catch_a3

    .line 228
    goto :goto_a4

    .line 226
    :catch_a3
    move-exception v0

    .line 229
    :goto_a4
    return-object v5

    .line 232
    :cond_a5
    const/4 v10, 0x1

    if-eq v6, v10, :cond_ca

    const/4 v2, 0x2

    if-ne v6, v2, :cond_ac

    goto :goto_ca

    .line 235
    :cond_ac
    if-nez v6, :cond_b1

    move/from16 v3, v16

    goto :goto_cf

    .line 236
    :cond_b1
    new-instance v0, Ljava/io/IOException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "unexpected opcode "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 233
    :cond_ca
    :goto_ca
    nop

    .line 234
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->reset()V

    move v3, v6

    .line 238
    :goto_cf
    invoke-virtual {v1, v8}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 240
    if-eqz v7, :cond_e3

    const/4 v15, -0x1

    if-eq v3, v15, :cond_e4

    .line 241
    new-instance v0, Ljava/lang/String;

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    return-object v0

    .line 240
    :cond_e3
    const/4 v15, -0x1

    .line 243
    :cond_e4
    goto/16 :goto_8

    .line 200
    :cond_e6
    new-instance v0, Ljava/io/IOException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "frame too large: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v12, v13}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method sendText(Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 125
    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    const/4 v0, 0x1

    invoke-direct {p0, v0, p1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendFrame(I[B)V

    .line 126
    return-void
.end method

.method setReadTimeout(I)V
    .registers 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 93
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mSocket:Ljava/net/Socket;

    if-eqz v0, :cond_9

    .line 94
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/WebSocketClient;->mSocket:Ljava/net/Socket;

    invoke-virtual {v0, p1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 96
    :cond_9
    return-void
.end method
