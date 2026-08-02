.class public final Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;
.super Landroid/app/Activity;
.source "CallAiVoiceActivity.java"


# static fields
.field private static final CACHE_DIR:Ljava/lang/String; = "voices"

.field private static final LABELS:[Ljava/lang/String;

.field private static final SAMPLE_RATE:I = 0x5dc0

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"

.field private static final TTS_MODEL:Ljava/lang/String; = "gemini-2.5-flash-preview-tts"

.field static final VOICES:[Ljava/lang/String;


# instance fields
.field private volatile mBusy:Z

.field private final mRows:[Landroid/widget/TextView;

.field private mSelected:Ljava/lang/String;

.field private volatile mTrack:Landroid/media/AudioTrack;


# direct methods
.method static bridge synthetic -$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Z)V
    .registers 2

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mBusy:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mplay(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;[S)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->play([S)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->post(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mpreview(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->preview(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$msample(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;Ljava/lang/String;)[S
    .registers 3

    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->sample(Ljava/lang/String;Ljava/lang/String;)[S

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mselect(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->select(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mtoast(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->toast(Ljava/lang/String;)V

    return-void
.end method

.method static constructor <clinit>()V
    .registers 13

    .line 43
    const-string v10, "Algieba"

    const-string v11, "Sadaltager"

    const-string v0, "Kore"

    const-string v1, "Zephyr"

    const-string v2, "Leda"

    const-string v3, "Aoede"

    const-string v4, "Sulafat"

    const-string v5, "Achernar"

    const-string v6, "Puck"

    const-string v7, "Charon"

    const-string v8, "Orus"

    const-string v9, "Fenrir"

    filled-new-array/range {v0 .. v11}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    .line 48
    const-string v11, "unica_ca_voice_algieba"

    const-string v12, "unica_ca_voice_sadaltager"

    const-string v1, "unica_ca_voice_kore"

    const-string v2, "unica_ca_voice_zephyr"

    const-string v3, "unica_ca_voice_leda"

    const-string v4, "unica_ca_voice_aoede"

    const-string v5, "unica_ca_voice_sulafat"

    const-string v6, "unica_ca_voice_achernar"

    const-string v7, "unica_ca_voice_puck"

    const-string v8, "unica_ca_voice_charon"

    const-string v9, "unica_ca_voice_orus"

    const-string v10, "unica_ca_voice_fenrir"

    filled-new-array/range {v1 .. v12}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->LABELS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 2

    .line 37
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 55
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    array-length v0, v0

    new-array v0, v0, [Landroid/widget/TextView;

    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mRows:[Landroid/widget/TextView;

    return-void
.end method

.method private dp(I)I
    .registers 3

    .line 305
    int-to-float p1, p1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, v0

    const/high16 v0, 0x3f000000    # 0.5f

    add-float/2addr p1, v0

    float-to-int p1, p1

    return p1
.end method

.method private paint(I)V
    .registers 7

    .line 118
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->LABELS:[Ljava/lang/String;

    aget-object v0, v0, p1

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 119
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_12

    .line 120
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    aget-object v0, v0, p1

    .line 122
    :cond_12
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    aget-object v1, v1, p1

    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mSelected:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    .line 123
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mRows:[Landroid/widget/TextView;

    aget-object v2, v2, p1

    if-eqz v1, :cond_25

    const-string v3, "\u2713  "

    goto :goto_27

    :cond_25
    const-string v3, "     "

    :goto_27
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 124
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mRows:[Landroid/widget/TextView;

    aget-object p1, v0, p1

    if-eqz v1, :cond_48

    const-string v0, "#1a73e8"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    goto :goto_4b

    :cond_48
    const v0, -0x777778

    :goto_4b
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 125
    return-void
.end method

.method private play([S)V
    .registers 7

    .line 251
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->stopTrack()V

    .line 252
    new-instance v0, Landroid/media/AudioTrack$Builder;

    invoke-direct {v0}, Landroid/media/AudioTrack$Builder;-><init>()V

    new-instance v1, Landroid/media/AudioAttributes$Builder;

    invoke-direct {v1}, Landroid/media/AudioAttributes$Builder;-><init>()V

    .line 254
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    .line 255
    invoke-virtual {v1, v2}, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v1

    .line 256
    invoke-virtual {v1}, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;

    move-result-object v1

    .line 253
    invoke-virtual {v0, v1}, Landroid/media/AudioTrack$Builder;->setAudioAttributes(Landroid/media/AudioAttributes;)Landroid/media/AudioTrack$Builder;

    move-result-object v0

    new-instance v1, Landroid/media/AudioFormat$Builder;

    invoke-direct {v1}, Landroid/media/AudioFormat$Builder;-><init>()V

    .line 258
    const/4 v3, 0x2

    invoke-virtual {v1, v3}, Landroid/media/AudioFormat$Builder;->setEncoding(I)Landroid/media/AudioFormat$Builder;

    move-result-object v1

    .line 259
    const/16 v4, 0x5dc0

    invoke-virtual {v1, v4}, Landroid/media/AudioFormat$Builder;->setSampleRate(I)Landroid/media/AudioFormat$Builder;

    move-result-object v1

    .line 260
    const/4 v4, 0x4

    invoke-virtual {v1, v4}, Landroid/media/AudioFormat$Builder;->setChannelMask(I)Landroid/media/AudioFormat$Builder;

    move-result-object v1

    .line 261
    invoke-virtual {v1}, Landroid/media/AudioFormat$Builder;->build()Landroid/media/AudioFormat;

    move-result-object v1

    .line 257
    invoke-virtual {v0, v1}, Landroid/media/AudioTrack$Builder;->setAudioFormat(Landroid/media/AudioFormat;)Landroid/media/AudioTrack$Builder;

    move-result-object v0

    array-length v1, p1

    mul-int/2addr v1, v3

    .line 262
    const/16 v3, 0x2000

    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/media/AudioTrack$Builder;->setBufferSizeInBytes(I)Landroid/media/AudioTrack$Builder;

    move-result-object v0

    .line 263
    invoke-virtual {v0, v2}, Landroid/media/AudioTrack$Builder;->setTransferMode(I)Landroid/media/AudioTrack$Builder;

    move-result-object v0

    .line 264
    invoke-virtual {v0}, Landroid/media/AudioTrack$Builder;->build()Landroid/media/AudioTrack;

    move-result-object v0

    .line 265
    iput-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mTrack:Landroid/media/AudioTrack;

    .line 266
    invoke-virtual {v0}, Landroid/media/AudioTrack;->play()V

    .line 267
    const/4 v1, 0x0

    array-length v2, p1

    invoke-virtual {v0, p1, v1, v2, v1}, Landroid/media/AudioTrack;->write([SIII)I

    .line 268
    invoke-virtual {v0}, Landroid/media/AudioTrack;->stop()V

    .line 269
    return-void
.end method

.method private post(Ljava/lang/String;)V
    .registers 3

    .line 285
    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;

    invoke-direct {v0, p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;-><init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 291
    return-void
.end method

.method private preview(I)V
    .registers 5

    .line 136
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mBusy:Z

    if-eqz v0, :cond_5

    .line 137
    return-void

    .line 139
    :cond_5
    const-string v0, "unica_ca_gemini_key"

    const-string v1, ""

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 140
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1d

    .line 141
    const-string p1, "unica_ca_voice_no_key"

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->toast(Ljava/lang/String;)V

    .line 142
    return-void

    .line 144
    :cond_1d
    const/4 v1, 0x1

    iput-boolean v1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mBusy:Z

    .line 145
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;

    invoke-direct {v2, p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;-><init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;ILjava/lang/String;)V

    const-string p1, "unica-voice-preview"

    invoke-direct {v1, v2, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 162
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 163
    return-void
.end method

.method private static read(Ljava/io/File;)[S
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 232
    new-instance v0, Ljava/io/RandomAccessFile;

    const-string v1, "r"

    invoke-direct {v0, p0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 233
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v1

    long-to-int p0, v1

    new-array p0, p0, [B

    .line 235
    :try_start_e
    invoke-virtual {v0, p0}, Ljava/io/RandomAccessFile;->readFully([B)V
    :try_end_11
    .catchall {:try_start_e .. :try_end_11} :catchall_1a

    .line 237
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V

    .line 238
    nop

    .line 239
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->toShorts([B)[S

    move-result-object p0

    return-object p0

    .line 237
    :catchall_1a
    move-exception p0

    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V

    .line 238
    throw p0
.end method

.method private row(I)Landroid/view/View;
    .registers 10

    .line 82
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 83
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 84
    const/16 v2, 0x10

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 86
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 87
    const/high16 v3, 0x41880000    # 17.0f

    const/4 v4, 0x2

    invoke-virtual {v2, v4, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 88
    const/4 v3, 0x4

    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v5

    const/16 v6, 0xe

    invoke-direct {p0, v6}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v7

    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v3

    invoke-direct {p0, v6}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v6

    invoke-virtual {v2, v5, v7, v3, v6}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 89
    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x2

    const/high16 v6, 0x3f800000    # 1.0f

    invoke-direct {v3, v1, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 91
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mRows:[Landroid/widget/TextView;

    aput-object v2, v1, p1

    .line 92
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->paint(I)V

    .line 93
    new-instance v1, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$1;

    invoke-direct {v1, p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$1;-><init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 100
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 101
    const-string v3, "\u25b6"

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 102
    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v1, v4, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 103
    const/16 v3, 0x12

    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v4

    const/16 v5, 0xa

    invoke-direct {p0, v5}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v6

    invoke-direct {p0, v3}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v3

    invoke-direct {p0, v5}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v5

    invoke-virtual {v1, v4, v6, v3, v5}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 104
    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setClickable(Z)V

    .line 105
    new-instance v3, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;

    invoke-direct {v3, p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;-><init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 112
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 113
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 114
    return-object v0
.end method

.method private sample(Ljava/lang/String;Ljava/lang/String;)[S
    .registers 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 166
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "voices"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 167
    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-nez v1, :cond_14

    .line 168
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    .line 170
    :cond_14
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".pcm"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 171
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_41

    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long v0, v2, v4

    if-lez v0, :cond_41

    .line 172
    invoke-static {v1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->read(Ljava/io/File;)[S

    move-result-object p1

    return-object p1

    .line 175
    :cond_41
    const-string v0, "unica_ca_voice_sample_text"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 176
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_4f

    .line 177
    const-string v0, "\u0623\u0647\u0644\u0627\u064b\u060c \u0645\u0639\u0627\u0643 \u0627\u0644\u0645\u0633\u0627\u0639\u062f \u0627\u0644\u0630\u0643\u064a. \u0643\u064a\u0641 \u0623\u0642\u062f\u0631 \u0623\u0633\u0627\u0639\u062f\u0643\u061f"

    .line 183
    :cond_4f
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    .line 184
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    const-string v4, "text"

    invoke-virtual {v3, v4, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 185
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    invoke-virtual {v4, v0}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object v0

    const-string v4, "parts"

    invoke-virtual {v3, v4, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 186
    new-instance v3, Lorg/json/JSONArray;

    invoke-direct {v3}, Lorg/json/JSONArray;-><init>()V

    invoke-virtual {v3, v0}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object v0

    const-string v3, "contents"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 187
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "voiceName"

    invoke-virtual {v0, v3, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 188
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 189
    const-string v5, "prebuiltVoiceConfig"

    invoke-virtual {v3, v5, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    const-string v3, "voiceConfig"

    invoke-virtual {v0, v3, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 190
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    new-instance v3, Lorg/json/JSONArray;

    invoke-direct {v3}, Lorg/json/JSONArray;-><init>()V

    .line 191
    const-string v5, "AUDIO"

    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object v3

    const-string v5, "responseModalities"

    invoke-virtual {v0, v5, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 192
    const-string v3, "speechConfig"

    invoke-virtual {v0, v3, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    .line 190
    const-string v0, "generationConfig"

    invoke-virtual {v2, v0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 194
    new-instance p1, Ljava/util/HashMap;

    invoke-direct {p1}, Ljava/util/HashMap;-><init>()V

    .line 195
    const-string v0, "Content-Type"

    const-string v3, "application/json"

    invoke-interface {p1, v0, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 196
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent?key="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 198
    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0x7530

    invoke-static {p2, p1, v0, v2}, Lio/mesalabs/unica/settings/callai/Http;->postJson(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;I)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p1

    .line 199
    const/4 p2, 0x0

    if-eqz p1, :cond_15a

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->ok()Z

    move-result v0

    if-nez v0, :cond_f6

    goto :goto_15a

    .line 203
    :cond_f6
    new-instance v0, Lorg/json/JSONObject;

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->text()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 204
    const-string p1, "candidates"

    invoke-virtual {v0, p1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p1

    .line 205
    if-eqz p1, :cond_159

    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-nez v0, :cond_10e

    goto :goto_159

    .line 208
    :cond_10e
    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p1

    .line 209
    const-string v2, "content"

    invoke-virtual {p1, v2}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1, v4}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p1

    .line 210
    nop

    .line 211
    move v2, v0

    :goto_11f
    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_13b

    .line 212
    invoke-virtual {p1, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v3

    const-string v4, "inlineData"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    .line 213
    if-eqz v3, :cond_138

    .line 214
    const-string p1, "data"

    invoke-virtual {v3, p1, p2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 215
    goto :goto_13c

    .line 211
    :cond_138
    add-int/lit8 v2, v2, 0x1

    goto :goto_11f

    :cond_13b
    move-object p1, p2

    .line 218
    :goto_13c
    if-nez p1, :cond_13f

    .line 219
    return-object p2

    .line 221
    :cond_13f
    invoke-static {p1, v0}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p1

    .line 222
    new-instance p2, Ljava/io/FileOutputStream;

    invoke-direct {p2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 224
    :try_start_148
    invoke-virtual {p2, p1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_14b
    .catchall {:try_start_148 .. :try_end_14b} :catchall_154

    .line 226
    invoke-virtual {p2}, Ljava/io/FileOutputStream;->close()V

    .line 227
    nop

    .line 228
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->toShorts([B)[S

    move-result-object p1

    return-object p1

    .line 226
    :catchall_154
    move-exception p1

    invoke-virtual {p2}, Ljava/io/FileOutputStream;->close()V

    .line 227
    throw p1

    .line 206
    :cond_159
    :goto_159
    return-object p2

    .line 200
    :cond_15a
    :goto_15a
    if-nez p1, :cond_15e

    const/4 p1, -0x1

    goto :goto_160

    :cond_15e
    iget p1, p1, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    :goto_160
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "tts preview http "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "UnicaCallAi"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    return-object p2
.end method

.method private select(I)V
    .registers 3

    .line 128
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    aget-object p1, v0, p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mSelected:Ljava/lang/String;

    .line 129
    const-string p1, "unica_ca_live_voice"

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mSelected:Ljava/lang/String;

    invoke-static {p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 130
    const/4 p1, 0x0

    :goto_e
    sget-object v0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    array-length v0, v0

    if-ge p1, v0, :cond_19

    .line 131
    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->paint(I)V

    .line 130
    add-int/lit8 p1, p1, 0x1

    goto :goto_e

    .line 133
    :cond_19
    return-void
.end method

.method private stopTrack()V
    .registers 3

    .line 272
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mTrack:Landroid/media/AudioTrack;

    .line 273
    const/4 v1, 0x0

    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mTrack:Landroid/media/AudioTrack;

    .line 274
    if-eqz v0, :cond_12

    .line 276
    :try_start_7
    invoke-virtual {v0}, Landroid/media/AudioTrack;->pause()V

    .line 277
    invoke-virtual {v0}, Landroid/media/AudioTrack;->flush()V

    .line 278
    invoke-virtual {v0}, Landroid/media/AudioTrack;->release()V
    :try_end_10
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_10} :catch_11

    .line 280
    goto :goto_12

    .line 279
    :catch_11
    move-exception v0

    .line 282
    :cond_12
    :goto_12
    return-void
.end method

.method private str(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 300
    const-string v0, "string"

    invoke-static {v0, p1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 301
    if-nez p1, :cond_b

    const-string p1, ""

    goto :goto_f

    :cond_b
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->getString(I)Ljava/lang/String;

    move-result-object p1

    :goto_f
    return-object p1
.end method

.method private static toShorts([B)[S
    .registers 6

    .line 243
    array-length v0, p0

    div-int/lit8 v0, v0, 0x2

    new-array v1, v0, [S

    .line 244
    const/4 v2, 0x0

    :goto_6
    if-ge v2, v0, :cond_1b

    .line 245
    mul-int/lit8 v3, v2, 0x2

    aget-byte v4, p0, v3

    and-int/lit16 v4, v4, 0xff

    add-int/lit8 v3, v3, 0x1

    aget-byte v3, p0, v3

    shl-int/lit8 v3, v3, 0x8

    or-int/2addr v3, v4

    int-to-short v3, v3

    aput-short v3, v1, v2

    .line 244
    add-int/lit8 v2, v2, 0x1

    goto :goto_6

    .line 247
    :cond_1b
    return-object v1
.end method

.method private toast(Ljava/lang/String;)V
    .registers 3

    .line 294
    if-eqz p1, :cond_10

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_10

    .line 295
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 297
    :cond_10
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .registers 6

    .line 62
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 63
    const-string p1, "unica_ca_voice_preview_title"

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->setTitle(Ljava/lang/CharSequence;)V

    .line 64
    const-string p1, "unica_ca_live_voice"

    const-string v0, "Kore"

    invoke-static {p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->mSelected:Ljava/lang/String;

    .line 66
    new-instance p1, Landroid/widget/LinearLayout;

    invoke-direct {p1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 67
    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 68
    const/16 v0, 0x10

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->dp(I)I

    move-result v0

    .line 69
    invoke-virtual {p1, v0, v0, v0, v0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 71
    const/4 v0, 0x0

    :goto_29
    sget-object v1, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    array-length v1, v1

    if-ge v0, v1, :cond_38

    .line 72
    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->row(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 71
    add-int/lit8 v0, v0, 0x1

    goto :goto_29

    .line 75
    :cond_38
    new-instance v0, Landroid/widget/ScrollView;

    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 76
    new-instance v1, Landroid/view/ViewGroup$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p1, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 78
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->setContentView(Landroid/view/View;)V

    .line 79
    return-void
.end method

.method protected onStop()V
    .registers 1

    .line 310
    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    .line 311
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->stopTrack()V

    .line 312
    return-void
.end method
