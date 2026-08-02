.class final Lio/mesalabs/unica/settings/callai/LiveClient;
.super Ljava/lang/Object;
.source "LiveClient.java"


# static fields
.field private static final CONNECT_TIMEOUT_MS:I = 0x3a98

.field private static final HOST:Ljava/lang/String; = "generativelanguage.googleapis.com"

.field static final INPUT_RATE:I = 0x3e80

.field private static final MAX_LEAD_MS:J = 0x190L

.field static final OUTPUT_RATE:I = 0x5dc0

.field private static final PATH:Ljava/lang/String; = "/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent"

.field private static final READ_TIMEOUT_MS:I = 0xea60

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"


# instance fields
.field private final mContext:Landroid/content/Context;

.field private final mKey:Ljava/lang/String;

.field private final mModel:Ljava/lang/String;

.field private volatile mOpen:Z

.field private mPlayoutEnd:J

.field private final mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

.field private final mVoice:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .registers 4

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 51
    new-instance v0, Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/callai/WebSocketClient;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    .line 57
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mContext:Landroid/content/Context;

    .line 58
    const-string v0, "unica_ca_gemini_key"

    const-string v1, ""

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mKey:Ljava/lang/String;

    .line 59
    const-string v0, "unica_ca_live_model"

    const-string v1, "gemini-live-2.5-flash-preview"

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mModel:Ljava/lang/String;

    .line 61
    const-string v0, "unica_ca_live_voice"

    const-string v1, "Kore"

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mVoice:Ljava/lang/String;

    .line 63
    return-void
.end method

.method private static logTranscript(Lorg/json/JSONObject;)V
    .registers 1

    .line 189
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->transcript(Lorg/json/JSONObject;)V

    .line 190
    return-void
.end method

.method private play(Lio/mesalabs/unica/settings/callai/CallAudioBridge;[B)V
    .registers 8

    .line 196
    array-length v0, p2

    const/4 v1, 0x2

    if-ge v0, v1, :cond_5

    .line 197
    return-void

    .line 199
    :cond_5
    array-length v0, p2

    div-int/2addr v0, v1

    new-array v1, v0, [S

    .line 200
    const/4 v2, 0x0

    :goto_a
    if-ge v2, v0, :cond_1f

    .line 201
    mul-int/lit8 v3, v2, 0x2

    aget-byte v4, p2, v3

    and-int/lit16 v4, v4, 0xff

    add-int/lit8 v3, v3, 0x1

    aget-byte v3, p2, v3

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v3, v4

    int-to-short v3, v3

    aput-short v3, v1, v2

    .line 200
    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    .line 203
    :cond_1f
    const/16 p2, 0x5dc0

    const/16 v2, 0x1f40

    invoke-static {v1, v0, p2, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->resample([SIII)[S

    move-result-object p2

    .line 205
    array-length v0, p2

    invoke-virtual {p1, p2, v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->writeUplink([SI)V

    .line 207
    array-length p1, p2

    int-to-long p1, p1

    const-wide/16 v0, 0x3e8

    mul-long/2addr p1, v0

    const-wide/16 v0, 0x1f40

    div-long/2addr p1, v0

    .line 208
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 209
    iget-wide v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    cmp-long v2, v2, v0

    if-gez v2, :cond_3f

    .line 210
    iput-wide v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    .line 212
    :cond_3f
    iget-wide v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    add-long/2addr v2, p1

    iput-wide v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    .line 213
    iget-wide p1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    sub-long/2addr p1, v0

    .line 214
    const-wide/16 v0, 0x190

    cmp-long v2, p1, v0

    if-lez v2, :cond_5a

    .line 216
    sub-long/2addr p1, v0

    :try_start_4e
    invoke-static {p1, p2}, Ljava/lang/Thread;->sleep(J)V
    :try_end_51
    .catch Ljava/lang/InterruptedException; {:try_start_4e .. :try_end_51} :catch_52

    .line 219
    goto :goto_5a

    .line 217
    :catch_52
    move-exception p1

    .line 218
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 221
    :cond_5a
    :goto_5a
    return-void
.end method

.method private setupMessage()Ljava/lang/String;
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 85
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mVoice:Ljava/lang/String;

    .line 86
    const-string v3, "voiceName"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, "prebuiltVoiceConfig"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 87
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2}, Lorg/json/JSONArray;-><init>()V

    .line 88
    const-string v3, "AUDIO"

    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object v2

    const-string v3, "responseModalities"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    .line 89
    const-string v3, "voiceConfig"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const-string v2, "speechConfig"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 91
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mModel:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "models/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 92
    const-string v3, "model"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    .line 93
    const-string v2, "generationConfig"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2}, Lorg/json/JSONArray;-><init>()V

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mContext:Landroid/content/Context;

    .line 96
    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/Prompt;->build(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "text"

    invoke-virtual {v3, v5, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v3

    invoke-virtual {v2, v3}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object v2

    .line 95
    const-string v3, "parts"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v1

    .line 94
    const-string v2, "systemInstruction"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 97
    const-string v2, "inputAudioTranscription"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 98
    const-string v2, "outputAudioTranscription"

    invoke-virtual {v0, v2, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 100
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "setup"

    invoke-virtual {v1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method close()V
    .registers 2

    .line 228
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mOpen:Z

    .line 229
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->close()V

    .line 230
    return-void
.end method

.method connect()V
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 70
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mKey:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent?key="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x3a98

    const-string v3, "generativelanguage.googleapis.com"

    const/16 v4, 0x1bb

    invoke-virtual {v0, v3, v4, v1, v2}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->connect(Ljava/lang/String;ILjava/lang/String;I)V

    .line 71
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    const v1, 0xea60

    invoke-virtual {v0, v1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->setReadTimeout(I)V

    .line 72
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/LiveClient;->setupMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendText(Ljava/lang/String;)V

    .line 75
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->receiveText()Ljava/lang/String;

    move-result-object v0

    .line 76
    if-eqz v0, :cond_6b

    const-string v1, "setupComplete"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_6b

    .line 80
    const/4 v0, 0x1

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mOpen:Z

    .line 81
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mModel:Ljava/lang/String;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mVoice:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "live session up on "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " with voice "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "UnicaCallAi"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 82
    return-void

    .line 77
    :cond_6b
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-virtual {v1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->close()V

    .line 78
    new-instance v1, Ljava/lang/IllegalStateException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "live setup rejected: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1
.end method

.method greet(Ljava/lang/String;)V
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 108
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "The call has just been answered. Greet the caller now by saying: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 110
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 111
    const-string v1, "role"

    const-string v2, "user"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    .line 112
    const-string v3, "text"

    invoke-virtual {v2, v3, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {v1, p1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object p1

    const-string v1, "parts"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 113
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    .line 114
    invoke-virtual {v1, p1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object p1

    const-string v1, "turns"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 115
    const-string v0, "turnComplete"

    const/4 v1, 0x1

    invoke-virtual {p1, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object p1

    .line 116
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "clientContent"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendText(Ljava/lang/String;)V

    .line 117
    return-void
.end method

.method hasKey()Z
    .registers 2

    .line 66
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mKey:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method isOpen()Z
    .registers 2

    .line 224
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mOpen:Z

    return v0
.end method

.method pump(Lio/mesalabs/unica/settings/callai/CallAudioBridge;)Z
    .registers 10

    .line 141
    const-string v0, "UnicaCallAi"

    const/4 v1, 0x0

    :try_start_3
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    invoke-virtual {v2}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->receiveText()Ljava/lang/String;

    move-result-object v2
    :try_end_9
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_9} :catch_96

    .line 145
    nop

    .line 146
    if-nez v2, :cond_d

    .line 147
    return v1

    .line 151
    :cond_d
    const/4 v3, 0x1

    :try_start_e
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 152
    const-string v2, "goAway"

    invoke-virtual {v4, v2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_21

    .line 153
    const-string p1, "live server asked us to go away"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 154
    return v1

    .line 156
    :cond_21
    const-string v2, "serverContent"

    invoke-virtual {v4, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    .line 157
    if-nez v2, :cond_2a

    .line 158
    return v3

    .line 160
    :cond_2a
    const-string v4, "interrupted"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_37

    .line 164
    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mPlayoutEnd:J

    .line 165
    return v3

    .line 167
    :cond_37
    invoke-static {v2}, Lio/mesalabs/unica/settings/callai/LiveClient;->logTranscript(Lorg/json/JSONObject;)V

    .line 169
    const-string v4, "modelTurn"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    .line 170
    if-nez v2, :cond_43

    .line 171
    return v3

    .line 173
    :cond_43
    const-string v4, "parts"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    .line 174
    move v4, v1

    :goto_4a
    if-eqz v2, :cond_79

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_79

    .line 175
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    if-nez v5, :cond_5a

    .line 176
    const/4 v5, 0x0

    goto :goto_64

    :cond_5a
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    const-string v6, "inlineData"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    .line 177
    :goto_64
    if-nez v5, :cond_67

    .line 178
    goto :goto_76

    .line 180
    :cond_67
    const-string v6, "data"

    const-string v7, ""

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v5

    invoke-direct {p0, p1, v5}, Lio/mesalabs/unica/settings/callai/LiveClient;->play(Lio/mesalabs/unica/settings/callai/CallAudioBridge;[B)V
    :try_end_76
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_76} :catch_7a

    .line 174
    :goto_76
    add-int/lit8 v4, v4, 0x1

    goto :goto_4a

    .line 184
    :cond_79
    goto :goto_95

    .line 182
    :catch_7a
    move-exception p1

    .line 183
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "live message parse failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 185
    :goto_95
    return v3

    .line 142
    :catch_96
    move-exception p1

    .line 143
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "live receive failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 144
    return v1
.end method

.method sendAudio([SI)V
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 121
    mul-int/lit8 v0, p2, 0x2

    new-array v0, v0, [B

    .line 122
    const/4 v1, 0x0

    :goto_5
    if-ge v1, p2, :cond_1e

    .line 123
    mul-int/lit8 v2, v1, 0x2

    aget-short v3, p1, v1

    and-int/lit16 v3, v3, 0xff

    int-to-byte v3, v3

    aput-byte v3, v0, v2

    .line 124
    add-int/lit8 v2, v2, 0x1

    aget-short v3, p1, v1

    shr-int/lit8 v3, v3, 0x8

    and-int/lit16 v3, v3, 0xff

    int-to-byte v3, v3

    aput-byte v3, v0, v2

    .line 122
    add-int/lit8 v1, v1, 0x1

    goto :goto_5

    .line 126
    :cond_1e
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1}, Lorg/json/JSONObject;-><init>()V

    .line 127
    const/4 p2, 0x2

    invoke-static {v0, p2}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p2

    const-string v0, "data"

    invoke-virtual {p1, v0, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 128
    const-string p2, "mimeType"

    const-string v0, "audio/pcm;rate=16000"

    invoke-virtual {p1, p2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 129
    iget-object p2, p0, Lio/mesalabs/unica/settings/callai/LiveClient;->mSocket:Lio/mesalabs/unica/settings/callai/WebSocketClient;

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 130
    const-string v2, "audio"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    const-string v1, "realtimeInput"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    .line 129
    invoke-virtual {p2, p1}, Lio/mesalabs/unica/settings/callai/WebSocketClient;->sendText(Ljava/lang/String;)V

    .line 131
    return-void
.end method
