.class abstract Lio/mesalabs/unica/settings/callai/LlmClient;
.super Ljava/lang/Object;
.source "LlmClient.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;,
        Lio/mesalabs/unica/settings/callai/LlmClient$Gemini;,
        Lio/mesalabs/unica/settings/callai/LlmClient$Turn;
    }
.end annotation


# static fields
.field static final TIMEOUT_MS:I = 0x4e20


# instance fields
.field final mContext:Landroid/content/Context;

.field final mKey:Ljava/lang/String;

.field final mModel:Ljava/lang/String;

.field final mThinking:Z


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .registers 4

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mContext:Landroid/content/Context;

    .line 40
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->activeKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mKey:Ljava/lang/String;

    .line 41
    nop

    .line 42
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->defaultModel(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 41
    const-string v1, "unica_ca_model"

    invoke-static {p1, v1, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mModel:Ljava/lang/String;

    .line 43
    const-string v0, "unica_ca_thinking"

    const/4 v1, 0x0

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->getBoolean(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p1

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mThinking:Z

    .line 44
    return-void
.end method

.method static create(Landroid/content/Context;)Lio/mesalabs/unica/settings/callai/LlmClient;
    .registers 3

    .line 47
    const-string v0, "deepseek"

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_12

    .line 48
    new-instance v0, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;

    invoke-direct {v0, p0}, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;-><init>(Landroid/content/Context;)V

    goto :goto_17

    :cond_12
    new-instance v0, Lio/mesalabs/unica/settings/callai/LlmClient$Gemini;

    invoke-direct {v0, p0}, Lio/mesalabs/unica/settings/callai/LlmClient$Gemini;-><init>(Landroid/content/Context;)V

    .line 47
    :goto_17
    return-object v0
.end method

.method static newHistory()Ljava/util/List;
    .registers 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lio/mesalabs/unica/settings/callai/LlmClient$Turn;",
            ">;"
        }
    .end annotation

    .line 248
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0
.end method

.method static trimReply(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 75
    const-string v0, ""

    if-nez p0, :cond_5

    .line 76
    return-object v0

    .line 78
    :cond_5
    const-string v1, "*"

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v1, "#"

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 80
    const/16 v0, 0x3a

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    .line 81
    if-lez v0, :cond_38

    const/16 v1, 0x10

    if-ge v0, v1, :cond_38

    const/4 v1, 0x0

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_38

    .line 82
    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 84
    :cond_38
    return-object p0
.end method


# virtual methods
.method hasKey()Z
    .registers 2

    .line 52
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mKey:Ljava/lang/String;

    if-eqz v0, :cond_e

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mKey:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_e

    const/4 v0, 0x1

    goto :goto_f

    :cond_e
    const/4 v0, 0x0

    :goto_f
    return v0
.end method

.method abstract reply(Ljava/util/List;)Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lio/mesalabs/unica/settings/callai/LlmClient$Turn;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation
.end method

.method abstract supportsAudio()Z
.end method

.method systemPrompt()Ljava/lang/String;
    .registers 2

    .line 71
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LlmClient;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/Prompt;->build(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method transcribe([SII)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 62
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw p1
.end method
