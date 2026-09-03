.class Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;
.super Ljava/lang/Object;
.source "VoiceChangerAudioRecordHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "Session"
.end annotation


# static fields
.field static final FIFO_SIZE:I = 0x8000


# instance fields
.field air:Lio/mesalabs/unica/audio/Biquad;

.field channels:I

.field currentPreset:Ljava/lang/String;

.field currentSemi:F

.field fifo:[S

.field fifoCount:I

.field fifoHead:I

.field fifoTail:I

.field formant:Lio/mesalabs/unica/audio/Biquad;

.field hpf:Lio/mesalabs/unica/audio/Biquad;

.field notch:Lio/mesalabs/unica/audio/Biquad;

.field sampleRate:I

.field sonic:Lio/mesalabs/unica/audio/Sonic;

.field sonicTmp:[S


# direct methods
.method constructor <init>(II)V
    .locals 1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    new-instance v0, Lio/mesalabs/unica/audio/Biquad;

    invoke-direct {v0}, Lio/mesalabs/unica/audio/Biquad;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->hpf:Lio/mesalabs/unica/audio/Biquad;

    .line 19
    new-instance v0, Lio/mesalabs/unica/audio/Biquad;

    invoke-direct {v0}, Lio/mesalabs/unica/audio/Biquad;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->notch:Lio/mesalabs/unica/audio/Biquad;

    .line 20
    new-instance v0, Lio/mesalabs/unica/audio/Biquad;

    invoke-direct {v0}, Lio/mesalabs/unica/audio/Biquad;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->formant:Lio/mesalabs/unica/audio/Biquad;

    .line 21
    new-instance v0, Lio/mesalabs/unica/audio/Biquad;

    invoke-direct {v0}, Lio/mesalabs/unica/audio/Biquad;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->air:Lio/mesalabs/unica/audio/Biquad;

    .line 22
    const-string v0, ""

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentPreset:Ljava/lang/String;

    .line 23
    const v0, 0x4479c000    # 999.0f

    iput v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentSemi:F

    .line 28
    const v0, 0x8000

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifo:[S

    .line 29
    const/4 v0, 0x0

    iput v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoHead:I

    .line 30
    iput v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoTail:I

    .line 31
    iput v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    .line 32
    const/16 v0, 0x800

    new-array v0, v0, [S

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    .line 35
    iput p1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sampleRate:I

    .line 36
    iput p2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    .line 37
    new-instance v0, Lio/mesalabs/unica/audio/Sonic;

    invoke-direct {v0, p1, p2}, Lio/mesalabs/unica/audio/Sonic;-><init>(II)V

    iput-object v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    .line 38
    iget-object p1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    const/4 p2, 0x1

    invoke-virtual {p1, p2}, Lio/mesalabs/unica/audio/Sonic;->setQuality(I)V

    .line 39
    iget-object p1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    const/high16 p2, 0x3f800000    # 1.0f

    invoke-virtual {p1, p2}, Lio/mesalabs/unica/audio/Sonic;->setSpeed(F)V

    .line 40
    iget-object p1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    invoke-virtual {p1, p2}, Lio/mesalabs/unica/audio/Sonic;->setRate(F)V

    .line 41
    iget-object p1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    invoke-virtual {p1, p2}, Lio/mesalabs/unica/audio/Sonic;->setVolume(F)V

    .line 42
    return-void
.end method

.method private popFifo([SII)I
    .locals 4

    .line 172
    iget v0, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    invoke-static {p3, v0}, Ljava/lang/Math;->min(II)I

    move-result p3

    .line 173
    const/4 v0, 0x0

    :goto_0
    if-ge v0, p3, :cond_0

    .line 174
    add-int v1, p2, v0

    iget-object v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifo:[S

    iget v3, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoHead:I

    aget-short v2, v2, v3

    aput-short v2, p1, v1

    .line 175
    iget v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoHead:I

    add-int/lit8 v1, v1, 0x1

    const v2, 0x8000

    rem-int/2addr v1, v2

    iput v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoHead:I

    .line 176
    iget v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    add-int/lit8 v1, v1, -0x1

    iput v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    .line 173
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 178
    :cond_0
    return p3
.end method

.method private pushFifo([SI)V
    .locals 5

    .line 162
    const/4 v0, 0x0

    :goto_0
    if-ge v0, p2, :cond_1

    .line 163
    iget v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    const v2, 0x8000

    if-ge v1, v2, :cond_0

    .line 164
    iget-object v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifo:[S

    iget v3, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoTail:I

    aget-short v4, p1, v0

    aput-short v4, v1, v3

    .line 165
    iget v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoTail:I

    add-int/lit8 v1, v1, 0x1

    rem-int/2addr v1, v2

    iput v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoTail:I

    .line 166
    iget v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->fifoCount:I

    .line 162
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 169
    :cond_1
    return-void
.end method


# virtual methods
.method processShorts([SII)V
    .locals 5

    .line 182
    const-string v0, "persist.sys.unica.vc.preset"

    const-string v1, "normal"

    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 183
    nop

    .line 185
    :try_start_0
    const-string v2, "persist.sys.unica.vc.semitones"

    const-string v3, "0"

    invoke-static {v2, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 186
    goto :goto_0

    :catch_0
    move-exception v2

    const/4 v2, 0x0

    .line 188
    :goto_0
    invoke-virtual {p0, v0, v2}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->updatePreset(Ljava/lang/String;F)V

    .line 190
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const v1, 0x3c23d70a    # 0.01f

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    .line 191
    return-void

    .line 195
    :cond_0
    const/4 v0, 0x0

    if-nez p2, :cond_1

    .line 196
    move-object v1, p1

    goto :goto_1

    .line 198
    :cond_1
    new-array v1, p3, [S

    .line 199
    invoke-static {p1, p2, v1, v0, p3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 202
    :goto_1
    iget-object v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    iget v3, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    div-int v3, p3, v3

    invoke-virtual {v2, v1, v3}, Lio/mesalabs/unica/audio/Sonic;->writeShortToStream([SI)V

    .line 204
    iget-object v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    invoke-virtual {v1}, Lio/mesalabs/unica/audio/Sonic;->samplesAvailable()I

    move-result v1

    iget v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    mul-int v1, v1, v2

    .line 205
    :goto_2
    if-lez v1, :cond_3

    .line 206
    iget-object v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    array-length v2, v2

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 207
    iget-object v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    iget-object v3, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    iget v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    div-int/2addr v1, v4

    invoke-virtual {v2, v3, v1}, Lio/mesalabs/unica/audio/Sonic;->readShortFromStream([SI)I

    move-result v1

    iget v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    mul-int v1, v1, v2

    .line 208
    if-lez v1, :cond_3

    .line 209
    const/4 v2, 0x0

    :goto_3
    if-ge v2, v1, :cond_2

    .line 210
    iget-object v3, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    aget-short v3, v3, v2

    int-to-float v3, v3

    .line 211
    iget-object v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->hpf:Lio/mesalabs/unica/audio/Biquad;

    invoke-virtual {v4, v3}, Lio/mesalabs/unica/audio/Biquad;->run(F)F

    move-result v3

    .line 212
    iget-object v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->notch:Lio/mesalabs/unica/audio/Biquad;

    invoke-virtual {v4, v3}, Lio/mesalabs/unica/audio/Biquad;->run(F)F

    move-result v3

    .line 213
    iget-object v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->formant:Lio/mesalabs/unica/audio/Biquad;

    invoke-virtual {v4, v3}, Lio/mesalabs/unica/audio/Biquad;->run(F)F

    move-result v3

    .line 214
    iget-object v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->air:Lio/mesalabs/unica/audio/Biquad;

    invoke-virtual {v4, v3}, Lio/mesalabs/unica/audio/Biquad;->run(F)F

    move-result v3

    .line 215
    iget-object v4, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    invoke-virtual {p0, v3}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->softLimit(F)S

    move-result v3

    aput-short v3, v4, v2

    .line 209
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 217
    :cond_2
    iget-object v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonicTmp:[S

    invoke-direct {p0, v2, v1}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->pushFifo([SI)V

    .line 221
    iget-object v1, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    invoke-virtual {v1}, Lio/mesalabs/unica/audio/Sonic;->samplesAvailable()I

    move-result v1

    iget v2, p0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->channels:I

    mul-int v1, v1, v2

    .line 222
    goto :goto_2

    .line 224
    :cond_3
    invoke-direct {p0, p1, p2, p3}, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->popFifo([SII)I

    move-result v1

    .line 225
    if-ge v1, p3, :cond_4

    .line 226
    add-int/2addr v1, p2

    :goto_4
    add-int v2, p2, p3

    if-ge v1, v2, :cond_4

    .line 227
    aput-short v0, p1, v1

    .line 226
    add-int/lit8 v1, v1, 0x1

    goto :goto_4

    .line 230
    :cond_4
    return-void
.end method

.method softLimit(F)S
    .locals 5

    .line 150
    nop

    .line 151
    nop

    .line 152
    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result v0

    .line 153
    const v1, 0x46bb8000    # 24000.0f

    cmpg-float v2, v0, v1

    if-gtz v2, :cond_0

    float-to-int p1, p1

    int-to-short p1, p1

    return p1

    .line 154
    :cond_0
    const/4 v2, 0x0

    const/high16 v3, 0x3f800000    # 1.0f

    cmpg-float p1, p1, v2

    if-gez p1, :cond_1

    const/high16 p1, -0x40800000    # -1.0f

    goto :goto_0

    :cond_1
    const/high16 p1, 0x3f800000    # 1.0f

    .line 155
    :goto_0
    sub-float/2addr v0, v1

    const v2, 0x4608fc00    # 8767.0f

    div-float/2addr v0, v2

    .line 156
    cmpl-float v4, v0, v3

    if-lez v4, :cond_2

    goto :goto_1

    :cond_2
    move v3, v0

    .line 157
    :goto_1
    mul-float v0, v3, v3

    mul-float v0, v0, v3

    const/high16 v4, 0x40400000    # 3.0f

    div-float/2addr v0, v4

    sub-float/2addr v3, v0

    mul-float v2, v2, v3

    add-float/2addr v1, v2

    .line 158
    mul-float p1, p1, v1

    float-to-int p1, p1

    int-to-short p1, p1

    return p1
.end method

.method updatePreset(Ljava/lang/String;F)V
    .locals 21

    .line 45
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move/from16 v2, p2

    iget-object v3, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentPreset:Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const-string v4, "custom"

    if-eqz v3, :cond_1

    iget v3, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentSemi:F

    cmpl-float v3, v2, v3

    if-eqz v3, :cond_0

    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    .line 46
    :cond_0
    return-void

    .line 48
    :cond_1
    iput-object v1, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentPreset:Ljava/lang/String;

    .line 49
    iput v2, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->currentSemi:F

    .line 51
    nop

    .line 52
    nop

    .line 53
    nop

    .line 54
    nop

    .line 55
    nop

    .line 57
    const-string v3, "female"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/high16 v5, -0x40000000    # -2.0f

    const/high16 v6, 0x40600000    # 3.5f

    const/high16 v7, 0x45480000    # 3200.0f

    const/high16 v8, -0x3f800000    # -4.0f

    if-eqz v3, :cond_2

    .line 58
    nop

    .line 59
    nop

    .line 60
    nop

    .line 61
    nop

    .line 62
    const v1, 0x3fb851ec    # 1.44f

    const/high16 v2, 0x43430000    # 195.0f

    const/high16 v3, 0x43f00000    # 480.0f

    const v4, 0x450fc000    # 2300.0f

    const v10, 0x3fb33333    # 1.4f

    const v9, 0x3f99999a    # 1.2f

    const v13, 0x3fb33333    # 1.4f

    goto/16 :goto_0

    .line 63
    :cond_2
    const-string v3, "soft_girl"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const v11, 0x454e4000    # 3300.0f

    const/high16 v12, -0x3fa00000    # -3.5f

    const v13, 0x3fa66666    # 1.3f

    const/high16 v14, 0x40800000    # 4.0f

    if-eqz v3, :cond_3

    .line 64
    nop

    .line 65
    nop

    .line 66
    nop

    .line 67
    nop

    .line 68
    const v1, 0x3fc28f5c    # 1.52f

    const/high16 v2, 0x43520000    # 210.0f

    const/high16 v3, 0x44020000    # 520.0f

    const v4, 0x45192000    # 2450.0f

    const/high16 v9, 0x3fc00000    # 1.5f

    const/high16 v5, -0x40400000    # -1.5f

    const/high16 v6, 0x40800000    # 4.0f

    const v7, 0x454e4000    # 3300.0f

    const/high16 v8, -0x3fa00000    # -3.5f

    const v9, 0x3fa66666    # 1.3f

    const/high16 v13, 0x3fc00000    # 1.5f

    goto/16 :goto_0

    .line 69
    :cond_3
    const-string v3, "male"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const v15, 0x451c4000    # 2500.0f

    const/16 v16, 0x0

    const/high16 v17, 0x3f800000    # 1.0f

    if-eqz v3, :cond_4

    .line 70
    nop

    .line 71
    nop

    .line 72
    nop

    .line 73
    const v1, 0x3f47ae14    # 0.78f

    const/high16 v2, 0x42960000    # 75.0f

    const/high16 v8, -0x3fc00000    # -3.0f

    const/high16 v4, 0x430c0000    # 140.0f

    const v3, 0x451c4000    # 2500.0f

    const/4 v5, 0x0

    const/high16 v6, 0x40800000    # 4.0f

    const/4 v7, 0x0

    const v9, 0x3f99999a    # 1.2f

    const/high16 v13, 0x3f800000    # 1.0f

    goto/16 :goto_0

    .line 74
    :cond_4
    const-string v3, "radio"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/high16 v18, 0x452f0000    # 2800.0f

    if-eqz v3, :cond_5

    .line 75
    nop

    .line 76
    nop

    .line 77
    nop

    .line 78
    nop

    .line 79
    const v1, 0x3f63d70a    # 0.89f

    const/high16 v2, 0x42a00000    # 80.0f

    const/high16 v3, 0x43af0000    # 350.0f

    const/high16 v8, -0x3fc00000    # -3.0f

    const v9, 0x3f666666    # 0.9f

    const/high16 v6, 0x40000000    # 2.0f

    const v7, 0x45098000    # 2200.0f

    const/high16 v5, 0x40000000    # 2.0f

    const/high16 v4, 0x452f0000    # 2800.0f

    const/high16 v13, 0x3f800000    # 1.0f

    goto/16 :goto_0

    .line 80
    :cond_5
    const-string v3, "child"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const v19, 0x45228000    # 2600.0f

    if-eqz v3, :cond_6

    .line 81
    nop

    .line 82
    nop

    .line 83
    nop

    .line 84
    const v1, 0x3fd33333    # 1.65f

    const/high16 v2, 0x43700000    # 240.0f

    const/high16 v5, -0x40800000    # -1.0f

    const/4 v3, 0x0

    const v4, 0x45228000    # 2600.0f

    const/high16 v6, 0x40800000    # 4.0f

    const v7, 0x454e4000    # 3300.0f

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    goto/16 :goto_0

    .line 85
    :cond_6
    const-string v3, "old_man"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/high16 v11, 0x40400000    # 3.0f

    if-eqz v3, :cond_7

    .line 86
    nop

    .line 87
    nop

    .line 88
    nop

    .line 89
    const v1, 0x3f59999a    # 0.85f

    const/high16 v2, 0x42b40000    # 90.0f

    const/high16 v4, 0x43c80000    # 400.0f

    const/4 v3, 0x0

    const/high16 v5, -0x3fa00000    # -3.5f

    const/high16 v6, 0x40400000    # 3.0f

    const/high16 v7, 0x452f0000    # 2800.0f

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const/high16 v13, 0x3f800000    # 1.0f

    goto/16 :goto_0

    .line 90
    :cond_7
    const-string v3, "old_woman"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_8

    .line 91
    nop

    .line 92
    nop

    .line 93
    nop

    .line 94
    const v1, 0x3f9c28f6    # 1.22f

    const/high16 v2, 0x432a0000    # 170.0f

    const/high16 v4, 0x44e10000    # 1800.0f

    const/high16 v6, 0x40200000    # 2.5f

    const v7, 0x453b8000    # 3000.0f

    const/4 v3, 0x0

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const v13, 0x3f99999a    # 1.2f

    goto/16 :goto_0

    .line 95
    :cond_8
    const-string v3, "anonymous"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const v5, 0x3f4ccccd    # 0.8f

    if-eqz v3, :cond_9

    .line 96
    nop

    .line 97
    nop

    .line 98
    nop

    .line 99
    nop

    .line 100
    const v1, 0x3f3851ec    # 0.72f

    const/high16 v2, 0x42700000    # 60.0f

    const/high16 v3, 0x44480000    # 800.0f

    const/high16 v4, -0x3f600000    # -5.0f

    const/high16 v7, 0x437a0000    # 250.0f

    const v9, 0x3f666666    # 0.9f

    const/high16 v10, 0x44fa0000    # 2000.0f

    const/high16 v4, 0x437a0000    # 250.0f

    const/high16 v5, -0x3f800000    # -4.0f

    const/high16 v7, 0x44fa0000    # 2000.0f

    const/high16 v8, -0x3f600000    # -5.0f

    const v9, 0x3f4ccccd    # 0.8f

    const v13, 0x3f666666    # 0.9f

    goto/16 :goto_0

    .line 101
    :cond_9
    const-string v3, "walkie_talkie"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const v6, 0x3f19999a    # 0.6f

    const/high16 v12, 0x40a00000    # 5.0f

    if-eqz v3, :cond_a

    .line 102
    nop

    .line 103
    nop

    .line 104
    nop

    .line 105
    nop

    .line 106
    const/high16 v2, 0x43e10000    # 450.0f

    const/high16 v8, -0x3f000000    # -8.0f

    const v4, 0x44898000    # 1100.0f

    const v9, 0x3f333333    # 0.7f

    const/high16 v7, 0x45160000    # 2400.0f

    const/high16 v1, 0x3f800000    # 1.0f

    const v3, 0x45228000    # 2600.0f

    const/high16 v5, 0x40a00000    # 5.0f

    const/high16 v6, 0x40800000    # 4.0f

    const v9, 0x3f19999a    # 0.6f

    const v13, 0x3f333333    # 0.7f

    goto/16 :goto_0

    .line 107
    :cond_a
    const-string v3, "cyborg"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/high16 v20, 0x3f000000    # 0.5f

    if-eqz v3, :cond_b

    .line 108
    nop

    .line 109
    nop

    .line 110
    nop

    .line 111
    nop

    .line 112
    const/high16 v2, 0x42a00000    # 80.0f

    const/high16 v3, 0x44e10000    # 1800.0f

    const/high16 v4, 0x44610000    # 900.0f

    const v1, 0x3f4ccccd    # 0.8f

    const/high16 v5, 0x40400000    # 3.0f

    const/high16 v6, 0x40a00000    # 5.0f

    const v7, 0x451c4000    # 2500.0f

    const/high16 v8, 0x40a00000    # 5.0f

    const/high16 v9, 0x3f000000    # 0.5f

    const/high16 v13, 0x3f000000    # 0.5f

    goto/16 :goto_0

    .line 113
    :cond_b
    const-string v3, "chipmunk"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_c

    .line 114
    nop

    .line 115
    nop

    .line 116
    const v1, 0x3ff9999a    # 1.95f

    const/high16 v2, 0x43960000    # 300.0f

    const/4 v3, 0x0

    const/high16 v4, 0x452f0000    # 2800.0f

    const/4 v5, 0x0

    const/high16 v6, 0x40400000    # 3.0f

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const v13, 0x3f99999a    # 1.2f

    goto/16 :goto_0

    .line 117
    :cond_c
    const-string v3, "giant"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/high16 v11, 0x42c80000    # 100.0f

    if-eqz v3, :cond_d

    .line 118
    nop

    .line 119
    nop

    .line 120
    nop

    .line 121
    const/high16 v2, 0x42480000    # 50.0f

    const/high16 v1, 0x40c00000    # 6.0f

    const v1, 0x3f19999a    # 0.6f

    const/4 v3, 0x0

    const/high16 v4, 0x42c80000    # 100.0f

    const/high16 v5, -0x3f800000    # -4.0f

    const/high16 v6, 0x40c00000    # 6.0f

    const v7, 0x45228000    # 2600.0f

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const v13, 0x3f4ccccd    # 0.8f

    goto/16 :goto_0

    .line 122
    :cond_d
    const-string v3, "helium"

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_e

    .line 123
    nop

    .line 124
    const v1, 0x3fc66666    # 1.55f

    const/high16 v2, 0x435c0000    # 220.0f

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const/high16 v13, 0x3f800000    # 1.0f

    goto/16 :goto_0

    .line 125
    :cond_e
    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_11

    .line 126
    float-to-double v3, v2

    const-wide/high16 v18, 0x4028000000000000L    # 12.0

    invoke-static {v3, v4}, Ljava/lang/Double;->isNaN(D)Z

    div-double v3, v3, v18

    const-wide/high16 v9, 0x4000000000000000L    # 2.0

    invoke-static {v9, v10, v3, v4}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v3

    double-to-float v3, v3

    .line 127
    cmpl-float v4, v2, v17

    if-lez v4, :cond_f

    .line 128
    const/high16 v1, 0x41700000    # 15.0f

    mul-float v1, v1, v2

    add-float/2addr v1, v11

    const/high16 v4, 0x43960000    # 300.0f

    invoke-static {v1, v4}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 129
    const v4, 0x44bb8000    # 1500.0f

    mul-float v6, v2, v11

    add-float/2addr v6, v4

    invoke-static {v6, v7}, Ljava/lang/Math;->min(FF)F

    move-result v4

    .line 130
    mul-float v2, v2, v20

    invoke-static {v2, v14}, Ljava/lang/Math;->min(FF)F

    move-result v6

    .line 131
    nop

    .line 132
    move v2, v1

    move v1, v3

    const/4 v3, 0x0

    const/high16 v5, -0x40400000    # -1.5f

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    goto :goto_0

    .line 133
    :cond_f
    const/high16 v4, -0x40800000    # -1.0f

    cmpg-float v4, v2, v4

    if-gez v4, :cond_10

    .line 134
    nop

    .line 135
    nop

    .line 136
    neg-float v2, v2

    mul-float v2, v2, v6

    invoke-static {v2, v12}, Ljava/lang/Math;->min(FF)F

    move-result v6

    .line 137
    nop

    .line 138
    const/high16 v2, 0x428c0000    # 70.0f

    const/high16 v4, 0x430c0000    # 140.0f

    const/high16 v8, -0x3fe00000    # -2.5f

    move v1, v3

    const v3, 0x451c4000    # 2500.0f

    const/4 v5, 0x0

    const/4 v7, 0x0

    const v9, 0x3f99999a    # 1.2f

    const/high16 v13, 0x3f800000    # 1.0f

    goto :goto_0

    .line 133
    :cond_10
    move v1, v3

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const/high16 v13, 0x3f800000    # 1.0f

    goto :goto_0

    .line 125
    :cond_11
    const/high16 v1, 0x3f800000    # 1.0f

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/high16 v9, 0x3f800000    # 1.0f

    const/high16 v13, 0x3f800000    # 1.0f

    .line 142
    :goto_0
    iget-object v10, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sonic:Lio/mesalabs/unica/audio/Sonic;

    invoke-virtual {v10, v1}, Lio/mesalabs/unica/audio/Sonic;->setPitch(F)V

    .line 143
    iget-object v1, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->hpf:Lio/mesalabs/unica/audio/Biquad;

    iget v10, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sampleRate:I

    int-to-float v10, v10

    const v11, 0x3f350481    # 0.7071f

    invoke-virtual {v1, v10, v2, v11}, Lio/mesalabs/unica/audio/Biquad;->setHighpass(FFF)V

    .line 144
    iget-object v1, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->notch:Lio/mesalabs/unica/audio/Biquad;

    iget v2, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sampleRate:I

    int-to-float v2, v2

    invoke-virtual {v1, v2, v3, v9, v8}, Lio/mesalabs/unica/audio/Biquad;->setPeaking(FFFF)V

    .line 145
    iget-object v1, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->formant:Lio/mesalabs/unica/audio/Biquad;

    iget v2, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sampleRate:I

    int-to-float v2, v2

    invoke-virtual {v1, v2, v4, v13, v6}, Lio/mesalabs/unica/audio/Biquad;->setPeaking(FFFF)V

    .line 146
    iget-object v1, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->air:Lio/mesalabs/unica/audio/Biquad;

    iget v2, v0, Lio/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session;->sampleRate:I

    int-to-float v2, v2

    invoke-virtual {v1, v2, v7, v5}, Lio/mesalabs/unica/audio/Biquad;->setHighshelf(FFF)V

    .line 147
    return-void
.end method
