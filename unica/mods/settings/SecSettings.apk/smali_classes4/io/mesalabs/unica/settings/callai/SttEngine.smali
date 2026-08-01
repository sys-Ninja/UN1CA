.class final Lio/mesalabs/unica/settings/callai/SttEngine;
.super Ljava/lang/Object;
.source "SttEngine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/settings/callai/SttEngine$Listener;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"


# instance fields
.field private final mContext:Landroid/content/Context;

.field private final mLlm:Lio/mesalabs/unica/settings/callai/LlmClient;

.field private final mMode:Ljava/lang/String;


# direct methods
.method public static synthetic $r8$lambda$Ib0LHGTMEqILTbK2V-uGCw0ILxo(Lio/mesalabs/unica/settings/callai/SttEngine;[Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V
    .registers 5

    invoke-direct {p0, p1, p2, p3, p4}, Lio/mesalabs/unica/settings/callai/SttEngine;->lambda$local$0([Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V

    return-void
.end method

.method constructor <init>(Landroid/content/Context;Lio/mesalabs/unica/settings/callai/LlmClient;)V
    .registers 4

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mContext:Landroid/content/Context;

    .line 40
    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mLlm:Lio/mesalabs/unica/settings/callai/LlmClient;

    .line 41
    const-string p2, "unica_ca_stt"

    const-string v0, "auto"

    invoke-static {p1, p2, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mMode:Ljava/lang/String;

    .line 42
    return-void
.end method

.method private synthetic lambda$local$0([Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V
    .registers 8

    .line 100
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/speech/SpeechRecognizer;->createSpeechRecognizer(Landroid/content/Context;)Landroid/speech/SpeechRecognizer;

    move-result-object v0

    const/4 v1, 0x0

    aput-object v0, p1, v1

    .line 101
    aget-object v0, p1, v1

    new-instance v2, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;

    invoke-direct {v2, p2, p3}, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;-><init>([Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {v0, v2}, Landroid/speech/SpeechRecognizer;->setRecognitionListener(Landroid/speech/RecognitionListener;)V

    .line 102
    aget-object p1, p1, v1

    invoke-virtual {p1, p4}, Landroid/speech/SpeechRecognizer;->startListening(Landroid/content/Intent;)V

    .line 103
    return-void
.end method

.method static synthetic lambda$local$1([Landroid/speech/SpeechRecognizer;)V
    .registers 3

    .line 122
    const/4 v0, 0x0

    aget-object v1, p0, v0

    if-eqz v1, :cond_a

    .line 123
    aget-object p0, p0, v0

    invoke-virtual {p0}, Landroid/speech/SpeechRecognizer;->destroy()V

    .line 125
    :cond_a
    return-void
.end method

.method private languageTag()Ljava/lang/String;
    .registers 4

    .line 135
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mContext:Landroid/content/Context;

    const-string v1, "unica_ca_language"

    const-string v2, "ar"

    invoke-static {v0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 136
    const-string v1, "en"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_19

    .line 137
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {v0}, Ljava/util/Locale;->toLanguageTag()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 139
    :cond_19
    const-string v1, "ar_eg"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_24

    .line 140
    const-string v0, "ar-EG"

    return-object v0

    .line 142
    :cond_24
    return-object v2
.end method

.method private local([SI)Ljava/lang/String;
    .registers 16

    .line 69
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/speech/SpeechRecognizer;->isRecognitionAvailable(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    const-string v2, "UnicaCallAi"

    if-nez v0, :cond_11

    .line 70
    const-string p1, "no local recognition service"

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 71
    return-object v1

    .line 76
    :cond_11
    :try_start_11
    invoke-static {}, Landroid/os/ParcelFileDescriptor;->createPipe()[Landroid/os/ParcelFileDescriptor;

    move-result-object v3
    :try_end_15
    .catch Ljava/lang/Exception; {:try_start_11 .. :try_end_15} :catch_cc

    .line 80
    nop

    .line 82
    new-instance v9, Landroid/content/Intent;

    const-string v0, "android.speech.action.RECOGNIZE_SPEECH"

    invoke-direct {v9, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 83
    const-string v0, "android.speech.extra.LANGUAGE_MODEL"

    const-string v4, "free_form"

    invoke-virtual {v9, v0, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 85
    const-string v0, "android.speech.extra.LANGUAGE"

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/SttEngine;->languageTag()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v9, v0, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 86
    const-string v0, "android.speech.extra.AUDIO_SOURCE"

    const/4 v10, 0x0

    aget-object v4, v3, v10

    invoke-virtual {v9, v0, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 87
    const-string v0, "android.speech.extra.AUDIO_SOURCE_ENCODING"

    const/4 v4, 0x2

    invoke-virtual {v9, v0, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 89
    const-string v0, "android.speech.extra.AUDIO_SOURCE_SAMPLING_RATE"

    const/16 v11, 0x3e80

    invoke-virtual {v9, v0, v11}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 91
    const-string v0, "android.speech.extra.AUDIO_SOURCE_CHANNEL_COUNT"

    const/4 v12, 0x1

    invoke-virtual {v9, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 93
    new-array v7, v12, [Ljava/lang/String;

    aput-object v1, v7, v10

    .line 94
    new-instance v8, Ljava/util/concurrent/CountDownLatch;

    invoke-direct {v8, v12}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 95
    new-array v6, v12, [Landroid/speech/SpeechRecognizer;

    .line 96
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 99
    new-instance v4, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;

    move-object v5, p0

    invoke-direct/range {v4 .. v9}, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;-><init>(Lio/mesalabs/unica/settings/callai/SttEngine;[Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V

    invoke-virtual {v1, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 107
    :try_start_65
    new-instance v4, Landroid/os/ParcelFileDescriptor$AutoCloseOutputStream;

    aget-object v0, v3, v12

    invoke-direct {v4, v0}, Landroid/os/ParcelFileDescriptor$AutoCloseOutputStream;-><init>(Landroid/os/ParcelFileDescriptor;)V
    :try_end_6c
    .catch Ljava/lang/Exception; {:try_start_65 .. :try_end_6c} :catch_86

    .line 108
    :try_start_6c
    invoke-static {p1, p2, v11}, Lio/mesalabs/unica/settings/callai/Pcm;->toWav([SII)[B

    move-result-object p1

    invoke-virtual {v4, p1}, Ljava/io/OutputStream;->write([B)V

    .line 109
    invoke-virtual {v4}, Ljava/io/OutputStream;->flush()V
    :try_end_76
    .catchall {:try_start_6c .. :try_end_76} :catchall_7a

    .line 110
    :try_start_76
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V
    :try_end_79
    .catch Ljava/lang/Exception; {:try_start_76 .. :try_end_79} :catch_86

    .line 112
    goto :goto_a2

    .line 107
    :catchall_7a
    move-exception v0

    move-object p1, v0

    :try_start_7c
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V
    :try_end_7f
    .catchall {:try_start_7c .. :try_end_7f} :catchall_80

    goto :goto_85

    :catchall_80
    move-exception v0

    move-object p2, v0

    :try_start_82
    invoke-virtual {p1, p2}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_85
    throw p1
    :try_end_86
    .catch Ljava/lang/Exception; {:try_start_82 .. :try_end_86} :catch_86

    .line 110
    :catch_86
    move-exception v0

    move-object p1, v0

    .line 111
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "feeding the recogniser failed: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 115
    :goto_a2
    :try_start_a2
    sget-object p1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v4, 0xf

    invoke-virtual {v8, v4, v5, p1}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    move-result p1

    if-nez p1, :cond_b1

    .line 116
    const-string p1, "local stt timed out"

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_b1
    .catch Ljava/lang/InterruptedException; {:try_start_a2 .. :try_end_b1} :catch_b2

    .line 120
    :cond_b1
    goto :goto_ba

    .line 118
    :catch_b2
    move-exception v0

    .line 119
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 121
    :goto_ba
    new-instance p1, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda1;

    invoke-direct {p1, v6}, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda1;-><init>([Landroid/speech/SpeechRecognizer;)V

    invoke-virtual {v1, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 127
    :try_start_c2
    aget-object p1, v3, v10

    invoke-virtual {p1}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_c7
    .catch Ljava/lang/Exception; {:try_start_c2 .. :try_end_c7} :catch_c8

    .line 130
    goto :goto_c9

    .line 128
    :catch_c8
    move-exception v0

    .line 131
    :goto_c9
    aget-object p1, v7, v10

    return-object p1

    .line 77
    :catch_cc
    move-exception v0

    move-object p1, v0

    .line 78
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "could not create the audio pipe: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 79
    return-object v1
.end method


# virtual methods
.method transcribe([SI)Ljava/lang/String;
    .registers 6

    .line 47
    const-string v0, "provider"

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mMode:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_c

    .line 48
    const/4 v0, 0x1

    goto :goto_1e

    .line 49
    :cond_c
    const-string v0, "local"

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mMode:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_18

    .line 50
    const/4 v0, 0x0

    goto :goto_1e

    .line 54
    :cond_18
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mLlm:Lio/mesalabs/unica/settings/callai/LlmClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/LlmClient;->supportsAudio()Z

    move-result v0

    .line 57
    :goto_1e
    if-eqz v0, :cond_4e

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mLlm:Lio/mesalabs/unica/settings/callai/LlmClient;

    invoke-virtual {v0}, Lio/mesalabs/unica/settings/callai/LlmClient;->supportsAudio()Z

    move-result v0

    if-eqz v0, :cond_4e

    .line 59
    :try_start_28
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine;->mLlm:Lio/mesalabs/unica/settings/callai/LlmClient;

    const/16 v1, 0x3e80

    invoke-virtual {v0, p1, p2, v1}, Lio/mesalabs/unica/settings/callai/LlmClient;->transcribe([SII)Ljava/lang/String;

    move-result-object p1
    :try_end_30
    .catch Ljava/lang/Exception; {:try_start_28 .. :try_end_30} :catch_31

    return-object p1

    .line 60
    :catch_31
    move-exception v0

    .line 61
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "provider stt failed, trying local: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "UnicaCallAi"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 64
    :cond_4e
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/SttEngine;->local([SI)Ljava/lang/String;

    move-result-object p1

    .line 65
    if-nez p1, :cond_56

    const-string p1, ""

    :cond_56
    return-object p1
.end method
