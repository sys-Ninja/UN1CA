.class public final Lio/mesalabs/unica/settings/callai/CallAiService;
.super Landroid/app/Service;
.source "CallAiService.java"


# static fields
.field public static final ACTION_ANSWER_NOW:Ljava/lang/String; = "io.mesalabs.unica.callai.ANSWER_NOW"

.field public static final ACTION_START:Ljava/lang/String; = "io.mesalabs.unica.callai.START"

.field public static final ACTION_STOP:Ljava/lang/String; = "io.mesalabs.unica.callai.STOP"

.field private static final CHANNEL:Ljava/lang/String; = "unica_call_ai"

.field public static final EXTRA_NUMBER:Ljava/lang/String; = "number"

.field private static final FRAME:I = 0x140

.field private static final FRAMES_PER_SECOND:I = 0x32

.field private static final MAX_IDLE_FRAMES:I = 0x5dc

.field private static final MAX_UTTERANCE_FRAMES:I = 0x3e8

.field private static final NOTIFICATION_ID:I = 0xca1

.field private static final SILENCE_FRAMES:I = 0x28

.field private static final SPEECH_RMS:I = 0x2bc

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"


# instance fields
.field private final mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

.field private volatile mRunning:Z

.field private mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

.field private mWorker:Ljava/lang/Thread;


# direct methods
.method public static synthetic $r8$lambda$Ma6A0lC7CUW9TPRXR419KQi4NRk(Lio/mesalabs/unica/settings/callai/CallAiService;Ljava/lang/String;Z)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->lambda$onStartCommand$0(Ljava/lang/String;Z)V

    return-void
.end method

.method public constructor <init>()V
    .registers 2

    .line 27
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    .line 50
    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    return-void
.end method

.method private synthetic lambda$onStartCommand$0(Ljava/lang/String;Z)V
    .registers 3

    .line 74
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->run(Ljava/lang/String;Z)V

    return-void
.end method

.method private listen([S)I
    .registers 12

    .line 186
    const/16 v0, 0x140

    new-array v1, v0, [S

    .line 187
    nop

    .line 188
    nop

    .line 189
    nop

    .line 190
    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    move v5, v4

    move v6, v5

    .line 192
    :cond_c
    :goto_c
    iget-boolean v7, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    const/4 v8, -0x1

    if-eqz v7, :cond_4e

    .line 193
    iget-object v7, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {v7, v1, v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->readDownlink([SI)I

    move-result v7

    if-gez v7, :cond_1a

    .line 194
    return v8

    .line 196
    :cond_1a
    invoke-static {v1, v0}, Lio/mesalabs/unica/settings/callai/Pcm;->rms([SI)I

    move-result v7

    const/16 v8, 0x2bc

    const/4 v9, 0x1

    if-le v7, v8, :cond_25

    move v7, v9

    goto :goto_26

    :cond_25
    move v7, v2

    .line 198
    :goto_26
    if-nez v3, :cond_33

    .line 199
    if-eqz v7, :cond_2c

    .line 200
    move v3, v9

    goto :goto_33

    .line 201
    :cond_2c
    add-int/lit8 v4, v4, 0x1

    const/16 v7, 0x5dc

    if-le v4, v7, :cond_c

    .line 202
    return v2

    .line 208
    :cond_33
    :goto_33
    add-int/lit16 v8, v5, 0x140

    array-length v9, p1

    if-gt v8, v9, :cond_3c

    .line 209
    invoke-static {v1, v2, p1, v5, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 210
    move v5, v8

    .line 212
    :cond_3c
    if-eqz v7, :cond_40

    move v6, v2

    goto :goto_42

    :cond_40
    add-int/lit8 v6, v6, 0x1

    .line 213
    :goto_42
    const/16 v7, 0x28

    if-ge v6, v7, :cond_4d

    const v7, 0x4e200

    if-lt v5, v7, :cond_4c

    goto :goto_4d

    .line 216
    :cond_4c
    goto :goto_c

    .line 214
    :cond_4d
    :goto_4d
    return v5

    .line 217
    :cond_4e
    return v8
.end method

.method private notification()Landroid/app/Notification;
    .registers 8

    .line 80
    const-class v0, Landroid/app/NotificationManager;

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 81
    new-instance v1, Landroid/app/NotificationChannel;

    .line 82
    const-string v2, "string"

    const-string v3, "unica_ca_settings_title"

    invoke-static {v2, v3}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    invoke-virtual {p0, v4}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x2

    const-string v6, "unica_call_ai"

    invoke-direct {v1, v6, v4, v5}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .line 84
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    .line 85
    new-instance v0, Landroid/app/Notification$Builder;

    invoke-direct {v0, p0, v6}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 86
    const-string v1, "drawable"

    const-string v4, "ic_unica_settings_ca"

    invoke-static {v1, v4}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 87
    invoke-static {v2, v3}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 89
    const-string v1, "unica_ca_notification_text"

    invoke-static {v2, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 91
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 92
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    .line 85
    return-object v0
.end method

.method private static parseInt(Ljava/lang/String;I)I
    .registers 2

    .line 270
    :try_start_0
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_4
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_4} :catch_5

    return p0

    .line 271
    :catch_5
    move-exception p0

    .line 272
    return p1
.end method

.method private run(Ljava/lang/String;Z)V
    .registers 4

    .line 97
    :try_start_0
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->session(Ljava/lang/String;Z)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_3} :catch_9
    .catchall {:try_start_0 .. :try_end_3} :catchall_7

    .line 101
    :goto_3
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->teardown()V

    .line 102
    goto :goto_12

    .line 101
    :catchall_7
    move-exception p1

    goto :goto_13

    .line 98
    :catch_9
    move-exception p1

    .line 99
    :try_start_a
    const-string p2, "UnicaCallAi"

    const-string v0, "session failed"

    invoke-static {p2, v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_11
    .catchall {:try_start_a .. :try_end_11} :catchall_7

    goto :goto_3

    .line 103
    :goto_12
    return-void

    .line 101
    :goto_13
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->teardown()V

    .line 102
    throw p1
.end method

.method private session(Ljava/lang/String;Z)V
    .registers 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 106
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/LlmClient;->create(Landroid/content/Context;)Lio/mesalabs/unica/settings/callai/LlmClient;

    move-result-object v0

    .line 107
    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/LlmClient;->hasKey()Z

    move-result v1

    const-string v2, "UnicaCallAi"

    if-nez v1, :cond_12

    .line 108
    const-string p1, "no API key for the selected provider, not answering"

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 109
    return-void

    .line 112
    :cond_12
    const/4 v1, 0x0

    if-nez p2, :cond_32

    .line 113
    const-string p2, "unica_ca_delay"

    const-string v3, "0"

    invoke-static {p0, p2, v3}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-static {p2, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->parseInt(Ljava/lang/String;I)I

    move-result p2

    .line 114
    move v3, v1

    :goto_22
    mul-int/lit8 v4, p2, 0xa

    if-ge v3, v4, :cond_32

    iget-boolean v4, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v4, :cond_32

    .line 115
    const-wide/16 v4, 0x64

    invoke-static {v4, v5}, Ljava/lang/Thread;->sleep(J)V

    .line 114
    add-int/lit8 v3, v3, 0x1

    goto :goto_22

    .line 118
    :cond_32
    iget-boolean p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-nez p2, :cond_37

    .line 119
    return-void

    .line 122
    :cond_37
    if-nez p1, :cond_3c

    const-string p1, "unknown"

    goto :goto_3e

    :cond_3c
    const-string p1, "call"

    :goto_3e
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "answering "

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    const-class p1, Landroid/telecom/TelecomManager;

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telecom/TelecomManager;

    invoke-virtual {p1}, Landroid/telecom/TelecomManager;->acceptRingingCall()V

    .line 126
    const-string p1, "persist.sys.unica.ca.session"

    const-string p2, "true"

    invoke-static {p1, p2}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 127
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    const-wide/16 v3, 0x2710

    invoke-virtual {p1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->connect(J)Z

    move-result p1

    if-nez p1, :cond_71

    .line 128
    return-void

    .line 131
    :cond_71
    new-instance p1, Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-direct {p1, p0}, Lio/mesalabs/unica/settings/callai/TtsEngine;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    .line 132
    new-instance p1, Lio/mesalabs/unica/settings/callai/SttEngine;

    invoke-direct {p1, p0, v0}, Lio/mesalabs/unica/settings/callai/SttEngine;-><init>(Landroid/content/Context;Lio/mesalabs/unica/settings/callai/LlmClient;)V

    .line 133
    invoke-static {}, Lio/mesalabs/unica/settings/callai/LlmClient;->newHistory()Ljava/util/List;

    move-result-object p2

    .line 135
    const-string v3, "unica_ca_greeting"

    const-string v4, ""

    invoke-static {p0, v3, v4}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 136
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_9b

    .line 137
    const-string v3, "string"

    const-string v4, "unica_ca_greeting_default"

    invoke-static {v3, v4}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v3

    invoke-virtual {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v3

    .line 139
    :cond_9b
    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiService;->speak(Ljava/lang/String;)V

    .line 140
    new-instance v4, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    const-string v5, "model"

    invoke-direct {v4, v5, v3}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p2, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 142
    const v3, 0x61a80

    new-array v3, v3, [S

    .line 143
    :goto_ad
    iget-boolean v4, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v4, :cond_136

    .line 144
    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiService;->listen([S)I

    move-result v4

    .line 145
    if-gez v4, :cond_b9

    .line 146
    goto/16 :goto_136

    .line 148
    :cond_b9
    if-nez v4, :cond_bc

    .line 149
    goto :goto_ad

    .line 152
    :cond_bc
    invoke-virtual {p1, v3, v4}, Lio/mesalabs/unica/settings/callai/SttEngine;->transcribe([SI)Ljava/lang/String;

    move-result-object v4

    .line 153
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_cb

    .line 154
    goto :goto_ad

    .line 156
    :cond_cb
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "caller said "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " chars"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v2, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 157
    new-instance v6, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    const-string v7, "user"

    invoke-direct {v6, v7, v4}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p2, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 161
    :try_start_f5
    invoke-virtual {v0, p2}, Lio/mesalabs/unica/settings/callai/LlmClient;->reply(Ljava/util/List;)Ljava/lang/String;

    move-result-object v4
    :try_end_f9
    .catch Ljava/lang/Exception; {:try_start_f5 .. :try_end_f9} :catch_119

    .line 165
    nop

    .line 166
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_101

    .line 167
    goto :goto_ad

    .line 169
    :cond_101
    new-instance v6, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    invoke-direct {v6, v5, v4}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {p2, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 170
    invoke-direct {p0, v4}, Lio/mesalabs/unica/settings/callai/CallAiService;->speak(Ljava/lang/String;)V

    .line 173
    :goto_10c
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v4

    const/16 v6, 0x14

    if-le v4, v6, :cond_118

    .line 174
    invoke-interface {p2, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    goto :goto_10c

    .line 176
    :cond_118
    goto :goto_ad

    .line 162
    :catch_119
    move-exception v4

    .line 163
    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "model call failed: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 164
    goto/16 :goto_ad

    .line 177
    :cond_136
    :goto_136
    return-void
.end method

.method private speak(Ljava/lang/String;)V
    .registers 8

    .line 221
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-virtual {v0, p1}, Lio/mesalabs/unica/settings/callai/TtsEngine;->synthesize(Ljava/lang/String;)[S

    move-result-object p1

    .line 222
    if-eqz p1, :cond_37

    array-length v0, p1

    if-nez v0, :cond_c

    goto :goto_37

    .line 225
    :cond_c
    array-length v0, p1

    int-to-long v0, v0

    const-wide/16 v2, 0x3e8

    mul-long/2addr v0, v2

    const-wide/16 v2, 0x1f40

    div-long/2addr v0, v2

    .line 226
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 227
    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    array-length v5, p1

    invoke-virtual {v4, p1, v5}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->writeUplink([SI)V

    .line 231
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long/2addr v4, v2

    sub-long/2addr v0, v4

    .line 232
    const-wide/16 v2, 0x0

    cmp-long p1, v0, v2

    if-lez p1, :cond_36

    .line 234
    :try_start_2a
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_2d
    .catch Ljava/lang/InterruptedException; {:try_start_2a .. :try_end_2d} :catch_2e

    .line 237
    goto :goto_36

    .line 235
    :catch_2e
    move-exception p1

    .line 236
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 239
    :cond_36
    :goto_36
    return-void

    .line 223
    :cond_37
    :goto_37
    return-void
.end method

.method static start(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    .line 277
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lio/mesalabs/unica/settings/callai/CallAiService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 278
    invoke-virtual {v0, p1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 279
    const-string p1, "number"

    invoke-virtual {v0, p1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 280
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 281
    return-void
.end method

.method static stop(Landroid/content/Context;)V
    .registers 3

    .line 284
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lio/mesalabs/unica/settings/callai/CallAiService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 285
    const-string v1, "io.mesalabs.unica.callai.STOP"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 286
    invoke-virtual {p0, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 287
    return-void
.end method

.method private stopSession()V
    .registers 2

    .line 254
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 255
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    if-eqz v0, :cond_c

    .line 256
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 259
    :cond_c
    return-void
.end method

.method private teardown()V
    .registers 3

    .line 242
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->close()V

    .line 243
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    if-eqz v0, :cond_11

    .line 244
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/TtsEngine;->release()V

    .line 245
    const/4 v0, 0x0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    .line 247
    :cond_11
    const-string v0, "persist.sys.unica.ca.session"

    const-string v1, "false"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 248
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 249
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopForeground(I)V

    .line 250
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopSelf()V

    .line 251
    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .registers 2

    .line 55
    const/4 p1, 0x0

    return-object p1
.end method

.method public onDestroy()V
    .registers 3

    .line 263
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 264
    const-string v0, "persist.sys.unica.ca.session"

    const-string v1, "false"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 265
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    .line 266
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .registers 6

    .line 60
    const/4 p2, 0x0

    if-nez p1, :cond_5

    move-object p3, p2

    goto :goto_9

    :cond_5
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p3

    .line 61
    :goto_9
    const-string v0, "io.mesalabs.unica.callai.STOP"

    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x2

    if-eqz v0, :cond_16

    .line 62
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopSession()V

    .line 63
    return v1

    .line 65
    :cond_16
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v0, :cond_1b

    .line 66
    return v1

    .line 69
    :cond_1b
    const-string v0, "io.mesalabs.unica.callai.ANSWER_NOW"

    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    .line 70
    if-nez p1, :cond_24

    goto :goto_2a

    :cond_24
    const-string p2, "number"

    invoke-virtual {p1, p2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 72
    :goto_2a
    const/16 p1, 0xca1

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->notification()Landroid/app/Notification;

    move-result-object v0

    invoke-virtual {p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->startForeground(ILandroid/app/Notification;)V

    .line 73
    const/4 p1, 0x1

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 74
    new-instance p1, Ljava/lang/Thread;

    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p2, p3}, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda0;-><init>(Lio/mesalabs/unica/settings/callai/CallAiService;Ljava/lang/String;Z)V

    const-string p2, "unica-callai"

    invoke-direct {p1, v0, p2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    .line 75
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    .line 76
    return v1
.end method
