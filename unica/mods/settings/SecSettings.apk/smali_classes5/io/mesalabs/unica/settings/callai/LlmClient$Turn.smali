.class final Lio/mesalabs/unica/settings/callai/LlmClient$Turn;
.super Ljava/lang/Object;
.source "LlmClient.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/callai/LlmClient;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Turn"
.end annotation


# instance fields
.field final role:Ljava/lang/String;

.field final text:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 28
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;->role:Ljava/lang/String;

    .line 29
    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;->text:Ljava/lang/String;

    .line 30
    return-void
.end method
