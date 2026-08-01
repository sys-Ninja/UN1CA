.class final Lio/mesalabs/unica/settings/callai/TtsEngine;
.super Ljava/lang/Object;
.source "TtsEngine.java"


# static fields
.field private static final ELEVEN_RATE:I = 0x3e80

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"

.field private static final TIMEOUT_MS:I = 0x4e20


# instance fields
.field private final mContext:Landroid/content/Context;

.field private mTts:Landroid/speech/tts/TextToSpeech;

.field private volatile mTtsReady:Z

.field private final mUseEleven:Z


# direct methods
.method public static synthetic $r8$lambda$V8cbDZ7ZWcTeoams3WLcHKs8uqE(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;I)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/TtsEngine;->lambda$ensureLocalEngine$0(Ljava/util/concurrent/CountDownLatch;I)V

    return-void
.end method

.method constructor <init>(Landroid/content/Context;)V
    .registers 4

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    .line 40
    nop

    .line 41
    const-string v0, "unica_ca_tts"

    const-string v1, "local"

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 40
    const-string v0, "elevenlabs"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mUseEleven:Z

    .line 42
    return-void
.end method

.method private elevenLabs(Ljava/lang/String;)[S
    .registers 8

    .line 60
    const-string v0, "UnicaCallAi"

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    const-string v2, "unica_ca_eleven_key"

    const-string v3, ""

    invoke-static {v1, v2, v3}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 61
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    const-string v4, "unica_ca_eleven_voice"

    invoke-static {v2, v4, v3}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 62
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_c1

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_23

    goto/16 :goto_c1

    .line 66
    :cond_23
    :try_start_23
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 67
    const-string v5, "text"

    invoke-virtual {v3, v5, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 68
    const-string p1, "model_id"

    const-string v5, "eleven_multilingual_v2"

    invoke-virtual {v3, p1, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 70
    new-instance p1, Ljava/util/HashMap;

    invoke-direct {p1}, Ljava/util/HashMap;-><init>()V

    .line 71
    const-string v5, "xi-api-key"

    invoke-interface {p1, v5, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 72
    const-string v1, "Accept"

    const-string v5, "audio/pcm"

    invoke-interface {p1, v1, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 75
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "https://api.elevenlabs.io/v1/text-to-speech/"

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "?output_format=pcm_16000"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 77
    invoke-virtual {v3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    const/16 v3, 0x4e20

    invoke-static {v1, p1, v2, v3}, Lio/mesalabs/unica/settings/callai/Http;->postJson(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;I)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p1

    .line 78
    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->ok()Z

    move-result v1

    if-nez v1, :cond_95

    .line 79
    iget v1, p1, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->text()Ljava/lang/String;

    move-result-object p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "elevenlabs http "

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

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 80
    return-object v4

    .line 82
    :cond_95
    iget-object p1, p1, Lio/mesalabs/unica/settings/callai/Http$Response;->body:[B

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/Pcm;->fromWavOrRaw([B)[S

    move-result-object p1

    .line 83
    array-length v1, p1

    const/16 v2, 0x3e80

    const/16 v3, 0x1f40

    invoke-static {p1, v1, v2, v3}, Lio/mesalabs/unica/settings/callai/Pcm;->resample([SIII)[S

    move-result-object p1
    :try_end_a4
    .catch Ljava/lang/Exception; {:try_start_23 .. :try_end_a4} :catch_a5

    return-object p1

    .line 84
    :catch_a5
    move-exception p1

    .line 85
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "elevenlabs failed: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 86
    return-object v4

    .line 63
    :cond_c1
    :goto_c1
    return-object v4
.end method

.method private ensureLocalEngine()Z
    .registers 7

    .line 158
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTtsReady:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_6

    .line 159
    return v1

    .line 161
    :cond_6
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 162
    new-instance v2, Landroid/speech/tts/TextToSpeech;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    new-instance v4, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;

    invoke-direct {v4, p0, v0}, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;-><init>(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;)V

    invoke-direct {v2, v3, v4}, Landroid/speech/tts/TextToSpeech;-><init>(Landroid/content/Context;Landroid/speech/tts/TextToSpeech$OnInitListener;)V

    iput-object v2, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    .line 167
    const/4 v2, 0x0

    :try_start_1a
    sget-object v3, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v4, 0xa

    invoke-virtual {v0, v4, v5, v3}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    move-result v0

    if-eqz v0, :cond_34

    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTtsReady:Z
    :try_end_26
    .catch Ljava/lang/InterruptedException; {:try_start_1a .. :try_end_26} :catch_3c

    if-nez v0, :cond_29

    goto :goto_34

    .line 174
    :cond_29
    nop

    .line 175
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/TtsEngine;->locale()Ljava/util/Locale;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/speech/tts/TextToSpeech;->setLanguage(Ljava/util/Locale;)I

    .line 176
    return v1

    .line 168
    :cond_34
    :goto_34
    :try_start_34
    const-string v0, "UnicaCallAi"

    const-string v1, "local TTS engine unavailable"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3b
    .catch Ljava/lang/InterruptedException; {:try_start_34 .. :try_end_3b} :catch_3c

    .line 169
    return v2

    .line 171
    :catch_3c
    move-exception v0

    .line 172
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 173
    return v2
.end method

.method private synthetic lambda$ensureLocalEngine$0(Ljava/util/concurrent/CountDownLatch;I)V
    .registers 3

    .line 163
    if-nez p2, :cond_4

    const/4 p2, 0x1

    goto :goto_5

    :cond_4
    const/4 p2, 0x0

    :goto_5
    iput-boolean p2, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTtsReady:Z

    .line 164
    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 165
    return-void
.end method

.method private local(Ljava/lang/String;)[S
    .registers 12

    .line 91
    const-string v0, "could not delete "

    const-string v1, "UnicaCallAi"

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/TtsEngine;->ensureLocalEngine()Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_c

    .line 92
    return-object v3

    .line 94
    :cond_c
    new-instance v2, Ljava/io/File;

    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "unica_ca_tts.wav"

    invoke-direct {v2, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 95
    new-instance v4, Ljava/util/concurrent/CountDownLatch;

    const/4 v5, 0x1

    invoke-direct {v4, v5}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 96
    new-array v5, v5, [Z

    const/4 v6, 0x0

    aput-boolean v6, v5, v6

    .line 97
    nop

    .line 99
    iget-object v7, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    new-instance v8, Lio/mesalabs/unica/settings/callai/TtsEngine$1;

    invoke-direct {v8, p0, v4, v5}, Lio/mesalabs/unica/settings/callai/TtsEngine$1;-><init>(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;[Z)V

    invoke-virtual {v7, v8}, Landroid/speech/tts/TextToSpeech;->setOnUtteranceProgressListener(Landroid/speech/tts/UtteranceProgressListener;)I

    .line 117
    iget-object v7, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    new-instance v8, Landroid/os/Bundle;

    invoke-direct {v8}, Landroid/os/Bundle;-><init>()V

    const-string v9, "unica_ca"

    invoke-virtual {v7, p1, v8, v2, v9}, Landroid/speech/tts/TextToSpeech;->synthesizeToFile(Ljava/lang/CharSequence;Landroid/os/Bundle;Ljava/io/File;Ljava/lang/String;)I

    move-result p1

    if-eqz p1, :cond_3f

    .line 118
    return-object v3

    .line 121
    :cond_3f
    :try_start_3f
    sget-object p1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v7, 0x4e20

    invoke-virtual {v4, v7, v8, p1}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    move-result p1

    if-eqz p1, :cond_a3

    aget-boolean p1, v5, v6

    if-eqz p1, :cond_4e

    goto :goto_a3

    .line 124
    :cond_4e
    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v4

    long-to-int p1, v4

    new-array v4, p1, [B

    .line 125
    new-instance v5, Ljava/io/FileInputStream;

    invoke-direct {v5, v2}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_5a
    .catch Ljava/lang/Exception; {:try_start_3f .. :try_end_5a} :catch_c5
    .catchall {:try_start_3f .. :try_end_5a} :catchall_c3

    .line 126
    nop

    .line 127
    :goto_5b
    if-ge v6, p1, :cond_72

    .line 128
    sub-int v7, p1, v6

    :try_start_5f
    invoke-virtual {v5, v4, v6, v7}, Ljava/io/FileInputStream;->read([BII)I

    move-result v7
    :try_end_63
    .catchall {:try_start_5f .. :try_end_63} :catchall_68

    .line 129
    if-gez v7, :cond_66

    .line 130
    goto :goto_72

    .line 132
    :cond_66
    add-int/2addr v6, v7

    .line 133
    goto :goto_5b

    .line 125
    :catchall_68
    move-exception p1

    :try_start_69
    invoke-virtual {v5}, Ljava/io/FileInputStream;->close()V
    :try_end_6c
    .catchall {:try_start_69 .. :try_end_6c} :catchall_6d

    goto :goto_71

    :catchall_6d
    move-exception v4

    :try_start_6e
    invoke-virtual {p1, v4}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_71
    throw p1

    .line 134
    :cond_72
    :goto_72
    invoke-virtual {v5}, Ljava/io/FileInputStream;->close()V

    .line 135
    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/Pcm;->fromWavOrRaw([B)[S

    move-result-object p1

    .line 137
    invoke-static {v4}, Lio/mesalabs/unica/settings/callai/TtsEngine;->wavRate([B)I

    move-result v4

    .line 138
    array-length v5, p1

    const/16 v6, 0x1f40

    invoke-static {p1, v5, v4, v6}, Lio/mesalabs/unica/settings/callai/Pcm;->resample([SIII)[S

    move-result-object p1
    :try_end_84
    .catch Ljava/lang/Exception; {:try_start_6e .. :try_end_84} :catch_c5
    .catchall {:try_start_6e .. :try_end_84} :catchall_c3

    .line 143
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result v3

    if-nez v3, :cond_a2

    .line 144
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 138
    :cond_a2
    return-object p1

    .line 122
    :cond_a3
    :goto_a3
    nop

    .line 143
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result p1

    if-nez p1, :cond_c2

    .line 144
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 122
    :cond_c2
    return-object v3

    .line 143
    :catchall_c3
    move-exception p1

    goto :goto_100

    .line 139
    :catch_c5
    move-exception p1

    .line 140
    :try_start_c6
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "local tts failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_e0
    .catchall {:try_start_c6 .. :try_end_e0} :catchall_c3

    .line 141
    nop

    .line 143
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result p1

    if-nez p1, :cond_ff

    .line 144
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 141
    :cond_ff
    return-object v3

    .line 143
    :goto_100
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result v3

    if-nez v3, :cond_11e

    .line 144
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    :cond_11e
    throw p1
.end method

.method private locale()Ljava/util/Locale;
    .registers 4

    .line 180
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mContext:Landroid/content/Context;

    const-string v1, "unica_ca_language"

    const-string v2, "ar"

    invoke-static {v0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 181
    const-string v1, "en"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_15

    .line 182
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    return-object v0

    .line 184
    :cond_15
    const-string v1, "ar_eg"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_25

    .line 185
    new-instance v0, Ljava/util/Locale;

    const-string v1, "EG"

    invoke-direct {v0, v2, v1}, Ljava/util/Locale;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    .line 187
    :cond_25
    new-instance v0, Ljava/util/Locale;

    invoke-direct {v0, v2}, Ljava/util/Locale;-><init>(Ljava/lang/String;)V

    return-object v0
.end method

.method private static wavRate([B)I
    .registers 4

    .line 150
    array-length v0, p0

    const/16 v1, 0x2c

    if-lt v0, v1, :cond_2e

    const/4 v0, 0x0

    aget-byte v0, p0, v0

    const/16 v1, 0x52

    if-eq v0, v1, :cond_d

    goto :goto_2e

    .line 153
    :cond_d
    const/16 v0, 0x18

    aget-byte v1, p0, v0

    and-int/lit16 v1, v1, 0xff

    const/16 v2, 0x19

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x8

    or-int/2addr v1, v2

    const/16 v2, 0x1a

    aget-byte v2, p0, v2

    and-int/lit16 v2, v2, 0xff

    shl-int/lit8 v2, v2, 0x10

    or-int/2addr v1, v2

    const/16 v2, 0x1b

    aget-byte p0, p0, v2

    and-int/lit16 p0, p0, 0xff

    shl-int/2addr p0, v0

    or-int/2addr p0, v1

    return p0

    .line 151
    :cond_2e
    :goto_2e
    const/16 p0, 0x5622

    return p0
.end method


# virtual methods
.method release()V
    .registers 2

    .line 191
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    if-eqz v0, :cond_14

    .line 192
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    invoke-virtual {v0}, Landroid/speech/tts/TextToSpeech;->stop()I

    .line 193
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    invoke-virtual {v0}, Landroid/speech/tts/TextToSpeech;->shutdown()V

    .line 194
    const/4 v0, 0x0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTts:Landroid/speech/tts/TextToSpeech;

    .line 195
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mTtsReady:Z

    .line 197
    :cond_14
    return-void
.end method

.method synthesize(Ljava/lang/String;)[S
    .registers 4

    .line 46
    if-eqz p1, :cond_24

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_24

    .line 49
    :cond_d
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine;->mUseEleven:Z

    if-eqz v0, :cond_1f

    .line 50
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/TtsEngine;->elevenLabs(Ljava/lang/String;)[S

    move-result-object v0

    .line 51
    if-eqz v0, :cond_18

    .line 52
    return-object v0

    .line 54
    :cond_18
    const-string v0, "UnicaCallAi"

    const-string v1, "ElevenLabs failed, falling back to the local engine"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 56
    :cond_1f
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/TtsEngine;->local(Ljava/lang/String;)[S

    move-result-object p1

    return-object p1

    .line 47
    :cond_24
    :goto_24
    const/4 p1, 0x0

    return-object p1
.end method
