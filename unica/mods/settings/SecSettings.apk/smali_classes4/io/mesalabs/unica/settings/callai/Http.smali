.class final Lio/mesalabs/unica/settings/callai/Http;
.super Ljava/lang/Object;
.source "Http.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/settings/callai/Http$Response;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static drain(Ljava/io/InputStream;)[B
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 76
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 77
    const/16 v1, 0x2000

    new-array v1, v1, [B

    .line 79
    :goto_9
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_14

    .line 80
    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_9

    .line 82
    :cond_14
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method static get(Ljava/lang/String;Ljava/util/Map;I)Lio/mesalabs/unica/settings/callai/Http$Response;
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;I)",
            "Lio/mesalabs/unica/settings/callai/Http$Response;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 38
    const/4 v3, 0x0

    const/4 v4, 0x0

    const-string v0, "GET"

    move-object v1, p0

    move-object v2, p1

    move v5, p2

    invoke-static/range {v0 .. v5}, Lio/mesalabs/unica/settings/callai/Http;->request(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;[BI)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p0

    return-object p0
.end method

.method static postJson(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;I)Lio/mesalabs/unica/settings/callai/Http$Response;
    .registers 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            "I)",
            "Lio/mesalabs/unica/settings/callai/Http$Response;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 43
    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    .line 44
    invoke-virtual {p2, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v5

    .line 43
    const-string v1, "POST"

    const-string v4, "application/json; charset=utf-8"

    move-object v2, p0

    move-object v3, p1

    move v6, p3

    invoke-static/range {v1 .. v6}, Lio/mesalabs/unica/settings/callai/Http;->request(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;[BI)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p0

    return-object p0
.end method

.method private static request(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;[BI)Lio/mesalabs/unica/settings/callai/Http$Response;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            "[BI)",
            "Lio/mesalabs/unica/settings/callai/Http$Response;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 49
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p1

    check-cast p1, Ljava/net/HttpURLConnection;

    .line 51
    :try_start_b
    invoke-virtual {p1, p0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 52
    invoke-virtual {p1, p5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 53
    invoke-virtual {p1, p5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 54
    if-eqz p2, :cond_3a

    .line 55
    invoke-interface {p2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_1e
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_3a

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/util/Map$Entry;

    .line 56
    invoke-interface {p2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object p5

    check-cast p5, Ljava/lang/String;

    invoke-interface {p2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    invoke-virtual {p1, p5, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 57
    goto :goto_1e

    .line 59
    :cond_3a
    if-eqz p4, :cond_53

    .line 60
    const/4 p0, 0x1

    invoke-virtual {p1, p0}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    .line 61
    array-length p0, p4

    invoke-virtual {p1, p0}, Ljava/net/HttpURLConnection;->setFixedLengthStreamingMode(I)V

    .line 62
    const-string p0, "Content-Type"

    invoke-virtual {p1, p0, p3}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 63
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p0

    .line 64
    invoke-virtual {p0, p4}, Ljava/io/OutputStream;->write([B)V

    .line 65
    invoke-virtual {p0}, Ljava/io/OutputStream;->flush()V

    .line 67
    :cond_53
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p0

    .line 68
    const/16 p2, 0x190

    if-lt p0, p2, :cond_60

    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object p2

    goto :goto_64

    :cond_60
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p2

    .line 69
    :goto_64
    new-instance p3, Lio/mesalabs/unica/settings/callai/Http$Response;

    if-nez p2, :cond_6c

    const/4 p2, 0x0

    new-array p2, p2, [B

    goto :goto_70

    :cond_6c
    invoke-static {p2}, Lio/mesalabs/unica/settings/callai/Http;->drain(Ljava/io/InputStream;)[B

    move-result-object p2

    :goto_70
    invoke-direct {p3, p0, p2}, Lio/mesalabs/unica/settings/callai/Http$Response;-><init>(I[B)V
    :try_end_73
    .catchall {:try_start_b .. :try_end_73} :catchall_77

    .line 71
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 69
    return-object p3

    .line 71
    :catchall_77
    move-exception p0

    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 72
    throw p0
.end method
