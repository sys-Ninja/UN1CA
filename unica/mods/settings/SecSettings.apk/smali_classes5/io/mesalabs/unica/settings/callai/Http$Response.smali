.class final Lio/mesalabs/unica/settings/callai/Http$Response;
.super Ljava/lang/Object;
.source "Http.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/callai/Http;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Response"
.end annotation


# instance fields
.field final body:[B

.field final code:I


# direct methods
.method constructor <init>(I[B)V
    .registers 3

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 24
    iput p1, p0, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    .line 25
    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/Http$Response;->body:[B

    .line 26
    return-void
.end method


# virtual methods
.method ok()Z
    .registers 3

    .line 29
    iget v0, p0, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    const/16 v1, 0xc8

    if-lt v0, v1, :cond_e

    iget v0, p0, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    const/16 v1, 0x12c

    if-ge v0, v1, :cond_e

    const/4 v0, 0x1

    goto :goto_f

    :cond_e
    const/4 v0, 0x0

    :goto_f
    return v0
.end method

.method text()Ljava/lang/String;
    .registers 4

    .line 33
    new-instance v0, Ljava/lang/String;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/Http$Response;->body:[B

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, v1, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    return-object v0
.end method
