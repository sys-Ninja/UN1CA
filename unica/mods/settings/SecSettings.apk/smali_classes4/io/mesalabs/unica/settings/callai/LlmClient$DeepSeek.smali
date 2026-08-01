.class final Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;
.super Lio/mesalabs/unica/settings/callai/LlmClient;
.source "LlmClient.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/callai/LlmClient;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "DeepSeek"
.end annotation


# static fields
.field private static final URL:Ljava/lang/String; = "https://api.deepseek.com/chat/completions"


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .registers 2

    .line 221
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/LlmClient;-><init>(Landroid/content/Context;)V

    .line 222
    return-void
.end method


# virtual methods
.method reply(Ljava/util/List;)Ljava/lang/String;
    .registers 9
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

    .line 231
    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    .line 232
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "system"

    const-string v3, "role"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;->systemPrompt()Ljava/lang/String;

    move-result-object v2

    const-string v4, "content"

    invoke-virtual {v1, v4, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    invoke-virtual {v0, v1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 233
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_23
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const-string v2, "model"

    if-eqz v1, :cond_51

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    .line 234
    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    .line 235
    iget-object v6, v1, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;->role:Ljava/lang/String;

    invoke-virtual {v2, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_41

    const-string v2, "assistant"

    goto :goto_43

    :cond_41
    const-string v2, "user"

    :goto_43
    invoke-virtual {v5, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v2

    iget-object v1, v1, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;->text:Ljava/lang/String;

    .line 236
    invoke-virtual {v2, v4, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    .line 234
    invoke-virtual {v0, v1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 237
    goto :goto_23

    .line 239
    :cond_51
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1}, Lorg/json/JSONObject;-><init>()V

    .line 243
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;->mModel:Ljava/lang/String;

    invoke-virtual {p1, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 244
    const-string v1, "messages"

    invoke-virtual {p1, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 245
    const-string v0, "max_tokens"

    const/16 v1, 0x100

    invoke-virtual {p1, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 246
    const-string v0, "temperature"

    const-wide v1, 0x3fe6666666666666L    # 0.7

    invoke-virtual {p1, v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 248
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 249
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;->mKey:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Bearer "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "Authorization"

    invoke-interface {v0, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 251
    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    const/16 v1, 0x4e20

    const-string v2, "https://api.deepseek.com/chat/completions"

    invoke-static {v2, v0, p1, v1}, Lio/mesalabs/unica/settings/callai/Http;->postJson(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;I)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p1

    .line 252
    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->ok()Z

    move-result v0

    if-eqz v0, :cond_d4

    .line 255
    new-instance v0, Lorg/json/JSONObject;

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->text()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p1, "choices"

    invoke-virtual {v0, p1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p1

    .line 256
    const-string v0, ""

    if-eqz p1, :cond_d3

    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-nez v1, :cond_bc

    goto :goto_d3

    .line 259
    :cond_bc
    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p1

    const-string v1, "message"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p1

    .line 260
    if-nez p1, :cond_ca

    goto :goto_d2

    :cond_ca
    invoke-virtual {p1, v4, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/LlmClient$DeepSeek;->trimReply(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_d2
    return-object v0

    .line 257
    :cond_d3
    :goto_d3
    return-object v0

    .line 253
    :cond_d4
    new-instance v0, Ljava/lang/Exception;

    iget v1, p1, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->text()Ljava/lang/String;

    move-result-object p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "deepseek http "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method supportsAudio()Z
    .registers 2

    .line 226
    const/4 v0, 0x0

    return v0
.end method
