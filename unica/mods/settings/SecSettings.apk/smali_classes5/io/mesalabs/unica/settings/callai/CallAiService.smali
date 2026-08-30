.class public final Lio/mesalabs/unica/settings/callai/CallAiService;
.super Landroid/app/Service;
.source "CallAiService.java"

.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;


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

.field private mHandler:Landroid/os/Handler;

.field private mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

.field private mOverlay:Landroid/view/View;

.field private volatile mRunning:Z

.field private mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

.field private mUplinkPump:Ljava/lang/Thread;

.field private mWorker:Ljava/lang/Thread;


# direct methods
.method public static synthetic $r8$lambda$Ma6A0lC7CUW9TPRXR419KQi4NRk(Lio/mesalabs/unica/settings/callai/CallAiService;Ljava/lang/String;Z)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->lambda$onStartCommand$0(Ljava/lang/String;Z)V

    return-void
.end method

.method public static synthetic $r8$lambda$WkeNeyzrl7TGqh5yErrg1MdoTsg(Lio/mesalabs/unica/settings/callai/CallAiService;Lio/mesalabs/unica/settings/callai/LiveClient;)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->lambda$liveSession$1(Lio/mesalabs/unica/settings/callai/LiveClient;)V

    return-void
.end method

.method public constructor <init>()V
    .registers 3

    .line 27
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    .line 51
    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method private classicSession(Lio/mesalabs/unica/settings/callai/LlmClient;Ljava/lang/String;)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 190
    new-instance v0, Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-direct {v0, p0}, Lio/mesalabs/unica/settings/callai/TtsEngine;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    .line 191
    new-instance v0, Lio/mesalabs/unica/settings/callai/SttEngine;

    invoke-direct {v0, p0, p1}, Lio/mesalabs/unica/settings/callai/SttEngine;-><init>(Landroid/content/Context;Lio/mesalabs/unica/settings/callai/LlmClient;)V

    .line 192
    invoke-static {}, Lio/mesalabs/unica/settings/callai/LlmClient;->newHistory()Ljava/util/List;

    move-result-object v1

    .line 194
    invoke-direct {p0, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->speak(Ljava/lang/String;)V

    .line 195
    new-instance v2, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    const-string v3, "model"

    invoke-direct {v2, v3, p2}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 197
    const p2, 0x61a80

    new-array p2, p2, [S

    .line 198
    :goto_22
    iget-boolean v2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v2, :cond_ae

    .line 199
    invoke-direct {p0, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->listen([S)I

    move-result v2

    .line 200
    if-gez v2, :cond_2e

    .line 201
    goto/16 :goto_ae

    .line 203
    :cond_2e
    if-nez v2, :cond_31

    .line 204
    goto :goto_22

    .line 207
    :cond_31
    invoke-virtual {v0, p2, v2}, Lio/mesalabs/unica/settings/callai/SttEngine;->transcribe([SI)Ljava/lang/String;

    move-result-object v2

    .line 208
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_40

    .line 209
    goto :goto_22

    .line 211
    :cond_40
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "caller said "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " chars"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "UnicaCallAi"

    invoke-static {v5, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 212
    new-instance v4, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    const-string v6, "user"

    invoke-direct {v4, v6, v2}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 216
    :try_start_6c
    invoke-virtual {p1, v1}, Lio/mesalabs/unica/settings/callai/LlmClient;->reply(Ljava/util/List;)Ljava/lang/String;

    move-result-object v2
    :try_end_70
    .catch Ljava/lang/Exception; {:try_start_6c .. :try_end_70} :catch_91

    .line 220
    nop

    .line 221
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_78

    .line 222
    goto :goto_22

    .line 224
    :cond_78
    const-string v4, "[HANGUP]"

    invoke-virtual {v2, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_78_hangup

    const-string v4, "[hangup]"

    invoke-virtual {v2, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    :cond_78_hangup
    if-eqz v4, :cond_normal_speak

    const-string v4, "\\[(?i)hangup\\]"

    const-string v5, ""

    invoke-virtual {v2, v4, v5}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_78_end_call

    invoke-direct {p0, v2}, Lio/mesalabs/unica/settings/callai/CallAiService;->speak(Ljava/lang/String;)V

    :cond_78_end_call
    const-class v2, Landroid/telecom/TelecomManager;

    invoke-virtual {p0, v2}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telecom/TelecomManager;

    if-eqz v2, :cond_78_exit

    :try_start_end_call
    invoke-virtual {v2}, Landroid/telecom/TelecomManager;->endCall()Z
    :try_end_end_call
    .catch Ljava/lang/Exception; {:try_start_end_call .. :try_end_end_call} :catch_end_call

    :catch_end_call
    :cond_78_exit
    goto/16 :goto_ae

    :cond_normal_speak
    new-instance v4, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;

    invoke-direct {v4, v3, v2}, Lio/mesalabs/unica/settings/callai/LlmClient$Turn;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 225
    invoke-direct {p0, v2}, Lio/mesalabs/unica/settings/callai/CallAiService;->speak(Ljava/lang/String;)V

    .line 228
    :goto_83
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    const/16 v4, 0x14

    if-le v2, v4, :cond_90

    .line 229
    const/4 v2, 0x0

    invoke-interface {v1, v2}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    goto :goto_83

    .line 231
    :cond_90
    goto :goto_22

    .line 217
    :catch_91
    move-exception v2

    .line 218
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "model call failed: "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v5, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 219
    goto/16 :goto_22

    .line 232
    :cond_ae
    :goto_ae
    return-void
.end method

.method private synthetic lambda$liveSession$1(Lio/mesalabs/unica/settings/callai/LiveClient;)V
    .registers 2

    .line 157
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->pumpCallerAudio(Lio/mesalabs/unica/settings/callai/LiveClient;)V

    return-void
.end method

.method private synthetic lambda$onStartCommand$0(Ljava/lang/String;Z)V
    .registers 3

    .line 76
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->run(Ljava/lang/String;Z)V

    return-void
.end method

.method private listen([S)I
    .registers 12

    .line 241
    const/16 v0, 0x140

    new-array v1, v0, [S

    .line 242
    nop

    .line 243
    nop

    .line 244
    nop

    .line 245
    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    move v5, v4

    move v6, v5

    .line 247
    :cond_c
    :goto_c
    iget-boolean v7, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    const/4 v8, -0x1

    if-eqz v7, :cond_4e

    .line 248
    iget-object v7, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {v7, v1, v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->readDownlink([SI)I

    move-result v7

    if-gez v7, :cond_1a

    .line 249
    return v8

    .line 251
    :cond_1a
    invoke-static {v1, v0}, Lio/mesalabs/unica/settings/callai/Pcm;->rms([SI)I

    move-result v7

    const/16 v8, 0x3e8

    const/4 v9, 0x1

    if-le v7, v8, :cond_25

    move v7, v9

    goto :goto_26

    :cond_25
    move v7, v2

    .line 253
    :goto_26
    if-nez v3, :cond_33

    .line 254
    if-eqz v7, :cond_2c

    .line 255
    move v3, v9

    goto :goto_33

    .line 256
    :cond_2c
    add-int/lit8 v4, v4, 0x1

    const/16 v7, 0x5dc

    if-le v4, v7, :cond_c

    .line 257
    return v2

    .line 263
    :cond_33
    :goto_33
    add-int/lit16 v8, v5, 0x140

    array-length v9, p1

    if-gt v8, v9, :cond_3c

    .line 264
    invoke-static {v1, v2, p1, v5, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 265
    move v5, v8

    .line 267
    :cond_3c
    if-eqz v7, :cond_40

    move v6, v2

    goto :goto_42

    :cond_40
    add-int/lit8 v6, v6, 0x1

    .line 268
    :goto_42
    const/16 v7, 0x28

    if-ge v6, v7, :cond_4d

    const v7, 0x4e200

    if-lt v5, v7, :cond_4c

    goto :goto_4d

    .line 271
    :cond_4c
    goto :goto_c

    .line 269
    :cond_4d
    :goto_4d
    return v5

    .line 272
    :cond_4e
    return v8
.end method

.method private liveSession(Lio/mesalabs/unica/settings/callai/LiveClient;Ljava/lang/String;)V
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 153
    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/LiveClient;->connect()V

    .line 154
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    .line 155
    invoke-virtual {p1, p2}, Lio/mesalabs/unica/settings/callai/LiveClient;->greet(Ljava/lang/String;)V

    .line 157
    new-instance p2, Ljava/lang/Thread;

    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;-><init>(Lio/mesalabs/unica/settings/callai/CallAiService;Lio/mesalabs/unica/settings/callai/LiveClient;)V

    const-string v1, "unica-callai-up"

    invoke-direct {p2, v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mUplinkPump:Ljava/lang/Thread;

    .line 158
    iget-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mUplinkPump:Ljava/lang/Thread;

    invoke-virtual {p2}, Ljava/lang/Thread;->start()V

    .line 160
    :goto_1b
    iget-boolean p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz p2, :cond_28

    iget-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {p1, p2}, Lio/mesalabs/unica/settings/callai/LiveClient;->pump(Lio/mesalabs/unica/settings/callai/CallAudioBridge;)Z

    move-result p2

    if-eqz p2, :cond_28

    goto :goto_1b

    .line 163
    :cond_28
    return-void
.end method

.method private notification()Landroid/app/Notification;
    .registers 8

    .line 82
    const-class v0, Landroid/app/NotificationManager;

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 83
    new-instance v1, Landroid/app/NotificationChannel;

    .line 84
    const-string v2, "string"

    const-string v3, "unica_ca_settings_title"

    invoke-static {v2, v3}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    invoke-virtual {p0, v4}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x2

    const-string v6, "unica_call_ai"

    invoke-direct {v1, v6, v4, v5}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .line 86
    invoke-virtual {v0, v1}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    .line 87
    new-instance v0, Landroid/app/Notification$Builder;

    invoke-direct {v0, p0, v6}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 88
    const-string v1, "drawable"

    const-string v4, "ic_unica_settings_ca"

    invoke-static {v1, v4}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 89
    invoke-static {v2, v3}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 91
    const-string v1, "unica_ca_notification_text"

    invoke-static {v2, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    const-class v4, Lio/mesalabs/unica/settings/callai/CallAiService;

    invoke-direct {v1, p0, v4}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v4, "io.mesalabs.unica.callai.STOP"

    invoke-virtual {v1, v4}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v4, 0x0

    const/high16 v5, 0x4000000

    invoke-static {p0, v4, v1, v5}, Landroid/app/PendingIntent;->getService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v1

    const-string v4, "drawable"

    const-string v5, "ic_unica_settings_ca"

    invoke-static {v4, v5}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    invoke-static {p0, v4}, Landroid/graphics/drawable/Icon;->createWithResource(Landroid/content/Context;I)Landroid/graphics/drawable/Icon;

    move-result-object v4

    const-string v5, "unica_ca_takeover"

    invoke-static {v2, v5}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v5

    invoke-virtual {p0, v5}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v5

    new-instance v6, Landroid/app/Notification$Action$Builder;

    invoke-direct {v6, v4, v5, v1}, Landroid/app/Notification$Action$Builder;-><init>(Landroid/graphics/drawable/Icon;Ljava/lang/CharSequence;Landroid/app/PendingIntent;)V

    invoke-virtual {v6}, Landroid/app/Notification$Action$Builder;->build()Landroid/app/Notification$Action;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->addAction(Landroid/app/Notification$Action;)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 93
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 94
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    .line 87
    return-object v0
.end method

.method private static parseInt(Ljava/lang/String;I)I
    .registers 2

    .line 335
    :try_start_0
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_4
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_4} :catch_5

    return p0

    .line 336
    :catch_5
    move-exception p0

    .line 337
    return p1
.end method

.method private pumpCallerAudio(Lio/mesalabs/unica/settings/callai/LiveClient;)V
    .registers 9

    .line 167
    const/16 v0, 0x140

    new-array v1, v0, [S

    .line 168
    const/16 v2, 0x640

    new-array v3, v2, [S

    .line 169
    const/4 v4, 0x0

    move v5, v4

    .line 170
    :goto_a
    iget-boolean v6, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v6, :cond_42

    .line 171
    iget-object v6, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {v6, v1, v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->readDownlink([SI)I

    move-result v6

    if-gez v6, :cond_17

    .line 172
    goto :goto_42

    .line 174
    :cond_17
    invoke-static {v1, v4, v3, v5, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 175
    add-int/2addr v5, v0

    .line 176
    if-ge v5, v2, :cond_1e

    .line 177
    goto :goto_a

    .line 179
    :cond_1e
    nop

    invoke-static {v3, v2}, Lio/mesalabs/unica/settings/callai/Pcm;->rms([SI)I

    move-result v6

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/LiveClient;->isPlaying()Z

    move-result v7

    if-eqz v7, :cond_idle_gate

    const/16 v7, 0x898

    if-ge v6, v7, :cond_send_audio

    goto :goto_reset_buf

    :cond_idle_gate
    const/16 v7, 0x258

    if-ge v6, v7, :cond_send_audio

    goto :goto_reset_buf

    :cond_send_audio
    .line 181
    :try_start_1f
    invoke-virtual {p1, v3, v2}, Lio/mesalabs/unica/settings/callai/LiveClient;->sendAudio([SI)V
    :try_end_22
    .catch Ljava/lang/Exception; {:try_start_1f .. :try_end_22} :catch_24

    :goto_reset_buf
    .line 185
    move v5, v4

    goto :goto_a

    .line 182
    :catch_24
    move-exception p1

    .line 183
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "live uplink stopped: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "UnicaCallAi"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 184
    nop

    .line 187
    :cond_42
    :goto_42
    return-void
.end method

.method private run(Ljava/lang/String;Z)V
    .registers 4

    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/callai/CallRecorder;->start(Landroid/content/Context;Ljava/lang/String;)V

    .line 99
    :try_start_0
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->session(Ljava/lang/String;Z)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_3} :catch_9
    .catchall {:try_start_0 .. :try_end_3} :catchall_7

    .line 103
    :goto_3
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->teardown()V

    .line 104
    goto :goto_12

    .line 103
    :catchall_7
    move-exception p1

    goto :goto_13

    .line 100
    :catch_9
    move-exception p1

    .line 101
    :try_start_a
    const-string p2, "UnicaCallAi"

    const-string v0, "session failed"

    invoke-static {p2, v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_11
    .catchall {:try_start_a .. :try_end_11} :catchall_7

    goto :goto_3

    .line 105
    :goto_12
    return-void

    .line 103
    :goto_13
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->teardown()V

    .line 104
    throw p1
.end method

.method private session(Ljava/lang/String;Z)V
    .registers 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 108
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->isLive(Landroid/content/Context;)Z

    move-result v0

    .line 109
    const/4 v1, 0x0

    if-eqz v0, :cond_d

    new-instance v2, Lio/mesalabs/unica/settings/callai/LiveClient;

    invoke-direct {v2, p0}, Lio/mesalabs/unica/settings/callai/LiveClient;-><init>(Landroid/content/Context;)V

    goto :goto_e

    :cond_d
    move-object v2, v1

    .line 110
    :goto_e
    if-eqz v0, :cond_11

    goto :goto_15

    :cond_11
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/LlmClient;->create(Landroid/content/Context;)Lio/mesalabs/unica/settings/callai/LlmClient;

    move-result-object v1

    .line 111
    :goto_15
    const-string v3, "UnicaCallAi"

    if-eqz v0, :cond_20

    invoke-virtual {v2}, Lio/mesalabs/unica/settings/callai/LiveClient;->hasKey()Z

    move-result v4

    if-nez v4, :cond_2c

    goto :goto_26

    :cond_20
    invoke-virtual {v1}, Lio/mesalabs/unica/settings/callai/LlmClient;->hasKey()Z

    move-result v4

    if-nez v4, :cond_2c

    .line 112
    :goto_26
    const-string p1, "no API key for the selected provider, not answering"

    invoke-static {v3, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 113
    return-void

    .line 116
    :cond_2c
    if-nez p2, :cond_4c

    .line 117
    const-string p2, "unica_ca_delay"

    const-string v4, "0"

    invoke-static {p0, p2, v4}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const/4 v4, 0x0

    invoke-static {p2, v4}, Lio/mesalabs/unica/settings/callai/CallAiService;->parseInt(Ljava/lang/String;I)I

    move-result p2

    .line 118
    nop

    :goto_3c
    mul-int/lit8 v5, p2, 0xa

    if-ge v4, v5, :cond_4c

    iget-boolean v5, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v5, :cond_4c

    .line 119
    const-wide/16 v5, 0x64

    invoke-static {v5, v6}, Ljava/lang/Thread;->sleep(J)V

    .line 118
    add-int/lit8 v4, v4, 0x1

    goto :goto_3c

    .line 122
    :cond_4c
    iget-boolean p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-nez p2, :cond_51

    .line 123
    return-void

    .line 126
    :cond_51
    if-nez p1, :cond_56

    const-string p1, "unknown"

    goto :goto_58

    :cond_56
    const-string p1, "call"

    :goto_58
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "answering "

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v3, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    const-class p1, Landroid/telecom/TelecomManager;

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telecom/TelecomManager;

    invoke-virtual {p1}, Landroid/telecom/TelecomManager;->acceptRingingCall()V

    .line 130
    const-string p1, "persist.sys.unica.ca.session"

    const-string p2, "true"

    invoke-static {p1, p2}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 131
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    const-wide/16 v3, 0x2710

    invoke-virtual {p1, v3, v4}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->connect(J)Z

    move-result p1

    if-nez p1, :cond_8b

    .line 132
    return-void

    .line 135
    :cond_8b
    const-string p1, "unica_ca_greeting"

    const-string p2, ""

    invoke-static {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 136
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_a5

    .line 137
    const-string p1, "string"

    const-string p2, "unica_ca_greeting_default"

    invoke-static {p1, p2}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 140
    :cond_a5
    if-eqz v0, :cond_ab

    .line 141
    invoke-direct {p0, v2, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->liveSession(Lio/mesalabs/unica/settings/callai/LiveClient;Ljava/lang/String;)V

    goto :goto_ae

    .line 143
    :cond_ab
    invoke-direct {p0, v1, p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->classicSession(Lio/mesalabs/unica/settings/callai/LlmClient;Ljava/lang/String;)V

    .line 145
    :goto_ae
    return-void
.end method

.method private speak(Ljava/lang/String;)V
    .registers 8

    .line 276
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-virtual {v0, p1}, Lio/mesalabs/unica/settings/callai/TtsEngine;->synthesize(Ljava/lang/String;)[S

    move-result-object p1

    .line 277
    if-eqz p1, :cond_37

    array-length v0, p1

    if-nez v0, :cond_c

    goto :goto_37

    .line 280
    :cond_c
    array-length v0, p1

    int-to-long v0, v0

    const-wide/16 v2, 0x3e8

    mul-long/2addr v0, v2

    const-wide/16 v2, 0x1f40

    div-long/2addr v0, v2

    .line 281
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 282
    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    array-length v5, p1

    invoke-virtual {v4, p1, v5}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->writeUplink([SI)V

    .line 286
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long/2addr v4, v2

    sub-long/2addr v0, v4

    .line 287
    const-wide/16 v2, 0x0

    cmp-long p1, v0, v2

    if-lez p1, :cond_36

    .line 289
    :try_start_2a
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_2d
    .catch Ljava/lang/InterruptedException; {:try_start_2a .. :try_end_2d} :catch_2e

    .line 292
    goto :goto_36

    .line 290
    :catch_2e
    move-exception p1

    .line 291
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 294
    :cond_36
    :goto_36
    return-void

    .line 278
    :cond_37
    :goto_37
    return-void
.end method

.method static start(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    .line 342
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lio/mesalabs/unica/settings/callai/CallAiService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 343
    invoke-virtual {v0, p1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 344
    const-string p1, "number"

    invoke-virtual {v0, p1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 345
    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 346
    return-void
.end method

.method static stop(Landroid/content/Context;)V
    .registers 3

    .line 349
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lio/mesalabs/unica/settings/callai/CallAiService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 350
    const-string v1, "io.mesalabs.unica.callai.STOP"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 351
    invoke-virtual {p0, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 352
    return-void
.end method

.method private stopSession()V
    .registers 3

    .line 313
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 314
    const-string v0, "persist.sys.unica.ca.session"

    const-string v1, "false"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 317
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    if-eqz v0, :cond_c

    .line 318
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/LiveClient;->close()V

    .line 320
    :cond_c
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    if-eqz v0, :cond_15

    .line 321
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 324
    :cond_15
    return-void
.end method

.method private hideOverlay()V
    .registers 3

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mOverlay:Landroid/view/View;

    if-nez v0, :cond_5

    return-void

    :cond_5
    const-class v1, Landroid/view/WindowManager;

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    :try_start_d
    invoke-interface {v1, v0}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V
    :try_end_10
    .catch Ljava/lang/Exception; {:try_start_d .. :try_end_10} :catch_11

    goto :goto_12

    :catch_11
    move-exception v0

    :goto_12
    const/4 v0, 0x0

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mOverlay:Landroid/view/View;

    return-void
.end method

.method private showOverlay()V
    .registers 8

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mOverlay:Landroid/view/View;

    if-eqz v0, :cond_5

    return-void

    :cond_5
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "string"

    const-string v2, "unica_ca_takeover"

    invoke-static {v1, v2}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v1, 0x41800000    # 16.0f

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v1, 0x11

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setGravity(I)V

    sget-object v1, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v1, 0x5a

    const/16 v2, 0x30

    invoke-virtual {v0, v1, v2, v1, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    new-instance v1, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v2, -0xc16e01

    invoke-virtual {v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v2, 0x42c80000    # 100.0f

    invoke-virtual {v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Landroid/view/WindowManager$LayoutParams;

    const/4 v2, -0x2

    const/4 v3, -0x2

    const/16 v4, 0x7f6

    const/16 v5, 0x8

    const/4 v6, -0x3

    invoke-direct/range {v1 .. v6}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    const/16 v2, 0x51

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v2, 0x1f4

    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    const-class v2, Landroid/view/WindowManager;

    invoke-virtual {p0, v2}, Lio/mesalabs/unica/settings/callai/CallAiService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/WindowManager;

    :try_start_5f
    invoke-interface {v2, v0, v1}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mOverlay:Landroid/view/View;
    :try_end_63
    .catch Ljava/lang/Exception; {:try_start_5f .. :try_end_63} :catch_64

    goto :goto_70

    :catch_64
    move-exception v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "UnicaCallAi"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_70
    return-void
.end method

.method private teardown()V
    .registers 3

    .line 297
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 298
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    const/4 v1, 0x0

    if-eqz v0, :cond_f

    .line 299
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/LiveClient;->close()V

    .line 300
    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mLive:Lio/mesalabs/unica/settings/callai/LiveClient;

    .line 302
    :cond_f
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mBridge:Lio/mesalabs/unica/settings/callai/CallAudioBridge;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/CallAudioBridge;->close()V

    .line 303
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    if-eqz v0, :cond_1f

    .line 304
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/TtsEngine;->release()V

    .line 305
    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mTts:Lio/mesalabs/unica/settings/callai/TtsEngine;

    .line 307
    :cond_1f
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mHandler:Landroid/os/Handler;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    const-string v0, "persist.sys.unica.ca.session"

    const-string v1, "false"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 308
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopForeground(I)V

    .line 309
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopSelf()V

    invoke-static {}, Lio/mesalabs/unica/settings/callai/CallRecorder;->stop()V

    .line 310
    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .registers 2

    .line 57
    const/4 p1, 0x0

    return-object p1
.end method

.method public onClick(Landroid/view/View;)V
    .registers 2

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopSession()V

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->hideOverlay()V

    return-void
.end method

.method public run()V
    .registers 1

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->hideOverlay()V

    return-void
.end method

.method public onDestroy()V
    .registers 3

    .line 328
    const/4 v0, 0x0

    iput-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 329
    const-string v0, "persist.sys.unica.ca.session"

    const-string v1, "false"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 330
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    .line 331
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .registers 6

    .line 62
    const/4 p2, 0x0

    if-nez p1, :cond_5

    move-object p3, p2

    goto :goto_9

    :cond_5
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p3

    .line 63
    :goto_9
    const-string v0, "io.mesalabs.unica.callai.STOP"

    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x2

    if-eqz v0, :cond_16

    .line 64
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->stopSession()V

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->hideOverlay()V

    .line 65
    return v1

    .line 67
    :cond_16
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    if-eqz v0, :cond_1b

    .line 68
    return v1

    .line 71
    :cond_1b
    const-string v0, "io.mesalabs.unica.callai.ANSWER_NOW"

    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    .line 72
    if-nez p1, :cond_24

    goto :goto_2a

    :cond_24
    const-string p2, "number"

    invoke-virtual {p1, p2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 74
    :goto_2a
    const/16 p1, 0xca1

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->notification()Landroid/app/Notification;

    move-result-object v0

    invoke-virtual {p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiService;->startForeground(ILandroid/app/Notification;)V

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiService;->showOverlay()V

    .line 75
    const/4 p1, 0x1

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mRunning:Z

    .line 76
    new-instance p1, Ljava/lang/Thread;

    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p2, p3}, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda0;-><init>(Lio/mesalabs/unica/settings/callai/CallAiService;Ljava/lang/String;Z)V

    const-string p2, "unica-callai"

    invoke-direct {p1, v0, p2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    .line 77
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService;->mWorker:Ljava/lang/Thread;

    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    .line 78
    return v1
.end method
