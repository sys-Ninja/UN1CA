.class public final Lio/mesalabs/unica/settings/callai/CallAiLogActivity;
.super Landroid/app/Activity;
.source "CallAiLogActivity.java"


# static fields
.field private static final MAX_AUDIO_BYTES:I = 0x124f800

.field private static final SUMMARY_MODEL:Ljava/lang/String; = "gemini-2.5-flash"

.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"


# instance fields
.field private volatile mBusy:Z

.field private mList:Landroid/widget/LinearLayout;

.field private mPlayer:Landroid/media/MediaPlayer;


# direct methods
.method static bridge synthetic -$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Z)V
    .registers 2

    iput-boolean p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mBusy:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mask(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Ljava/io/File;Lorg/json/JSONObject;)Ljava/lang/String;
    .registers 4

    invoke-direct {p0, p1, p2, p3}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->ask(Ljava/lang/String;Ljava/io/File;Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mdelete(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->delete(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mplay(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->play(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->post(Ljava/lang/String;Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreload(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;)V
    .registers 1

    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->reload()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$msummarize(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->summarize(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtoast(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)V
    .registers 2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->toast(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 36
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private ask(Ljava/lang/String;Ljava/io/File;Lorg/json/JSONObject;)Ljava/lang/String;
    .registers 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 240
    const-string v0, "unica_ca_summary_prompt"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 241
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_e

    .line 242
    const-string v0, "Summarise this phone call in the caller\'s own language in at most four short bullet points: who called, what they wanted, what was agreed, and anything the user must follow up on."

    .line 247
    :cond_e
    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    .line 248
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "text"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v1, v0}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 250
    const-string v0, "transcript"

    const-string v2, ""

    invoke-virtual {p3, v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 251
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    const/4 v5, 0x0

    if-nez v4, :cond_3d

    .line 252
    new-instance p2, Lorg/json/JSONObject;

    invoke-direct {p2}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {p2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p2

    invoke-virtual {v1, p2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    goto :goto_75

    .line 254
    :cond_3d
    new-instance v0, Ljava/io/File;

    const-string v4, "file"

    invoke-virtual {p3, v4, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-direct {v0, p2, p3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->readCapped(Ljava/io/File;)[B

    move-result-object p2

    .line 255
    if-nez p2, :cond_4f

    .line 256
    return-object v5

    .line 258
    :cond_4f
    new-instance p3, Lorg/json/JSONObject;

    invoke-direct {p3}, Lorg/json/JSONObject;-><init>()V

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 259
    const-string v4, "mimeType"

    const-string v6, "audio/wav"

    invoke-virtual {v0, v4, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    .line 260
    const/4 v4, 0x2

    invoke-static {p2, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p2

    const-string v4, "data"

    invoke-virtual {v0, v4, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p2

    .line 258
    const-string v0, "inlineData"

    invoke-virtual {p3, v0, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p2

    invoke-virtual {v1, p2}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 263
    :goto_75
    new-instance p2, Lorg/json/JSONObject;

    invoke-direct {p2}, Lorg/json/JSONObject;-><init>()V

    new-instance p3, Lorg/json/JSONArray;

    invoke-direct {p3}, Lorg/json/JSONArray;-><init>()V

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 264
    const-string v4, "parts"

    invoke-virtual {v0, v4, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {p3, v0}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    move-result-object p3

    .line 263
    const-string v0, "contents"

    invoke-virtual {p2, v0, p3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p2

    .line 266
    new-instance p3, Ljava/util/HashMap;

    invoke-direct {p3}, Ljava/util/HashMap;-><init>()V

    .line 267
    const-string v0, "Content-Type"

    const-string v1, "application/json"

    invoke-interface {p3, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 268
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 270
    invoke-virtual {p2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p2

    const v0, 0xea60

    invoke-static {p1, p3, p2, v0}, Lio/mesalabs/unica/settings/callai/Http;->postJson(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;I)Lio/mesalabs/unica/settings/callai/Http$Response;

    move-result-object p1

    .line 271
    if-eqz p1, :cond_112

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->ok()Z

    move-result p2

    if-nez p2, :cond_c7

    goto :goto_112

    .line 275
    :cond_c7
    new-instance p2, Lorg/json/JSONObject;

    invoke-virtual {p1}, Lio/mesalabs/unica/settings/callai/Http$Response;->text()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p2, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p1, "candidates"

    invoke-virtual {p2, p1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p1

    .line 276
    if-eqz p1, :cond_111

    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result p2

    if-nez p2, :cond_df

    goto :goto_111

    .line 279
    :cond_df
    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p1

    .line 280
    const-string p3, "content"

    invoke-virtual {p1, p3}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1, v4}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p1

    .line 281
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    .line 282
    nop

    :goto_f4
    invoke-virtual {p1}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-ge p2, v0, :cond_108

    .line 283
    invoke-virtual {p1, p2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0, v3, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 282
    add-int/lit8 p2, p2, 0x1

    goto :goto_f4

    .line 285
    :cond_108
    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 277
    :cond_111
    :goto_111
    return-object v5

    .line 272
    :cond_112
    :goto_112
    if-nez p1, :cond_116

    const/4 p1, -0x1

    goto :goto_118

    :cond_116
    iget p1, p1, Lio/mesalabs/unica/settings/callai/Http$Response;->code:I

    :goto_118
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "summary http "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "UnicaCallAi"

    invoke-static {p2, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 273
    return-object v5
.end method

.method private button(Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;
    .registers 7

    .line 142
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 143
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 144
    const/4 p1, 0x2

    const/high16 v1, 0x41600000    # 14.0f

    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 145
    const-string p1, "#1a73e8"

    invoke-static {p1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 146
    const/4 p1, 0x6

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v1

    const/16 v2, 0x1c

    invoke-direct {p0, v2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v2

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result p1

    const/4 v3, 0x0

    invoke-virtual {v0, v3, v1, v2, p1}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 147
    const/4 p1, 0x1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setClickable(Z)V

    .line 148
    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 149
    return-object v0
.end method

.method private delete(I)V
    .registers 10

    .line 185
    :try_start_0
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    .line 186
    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->readIndex(Ljava/io/File;)Lorg/json/JSONArray;

    move-result-object v1

    .line 187
    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2}, Lorg/json/JSONArray;-><init>()V

    .line 188
    const/4 v3, 0x0

    :goto_e
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_35

    .line 189
    if-ne v3, p1, :cond_2b

    .line 190
    new-instance v4, Ljava/io/File;

    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    const-string v6, "file"

    const-string v7, ""

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v0, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    goto :goto_32

    .line 192
    :cond_2b
    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->get(I)Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 188
    :goto_32
    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    .line 195
    :cond_35
    invoke-static {v0, v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->writeIndex(Ljava/io/File;Lorg/json/JSONArray;)V
    :try_end_38
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_38} :catch_39

    .line 198
    goto :goto_56

    .line 196
    :catch_39
    move-exception p1

    .line 197
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "delete failed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "UnicaCallAi"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 199
    :goto_56
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->reload()V

    .line 200
    return-void
.end method

.method private dp(I)I
    .registers 3

    .line 341
    int-to-float p1, p1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->getResources()Landroid/content/res/Resources;

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

.method private entry(Lorg/json/JSONObject;I)Landroid/view/View;
    .registers 21

    .line 82
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move/from16 v2, p2

    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 83
    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 84
    const/16 v5, 0xa

    invoke-direct {v0, v5}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v6

    invoke-direct {v0, v5}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v5

    const/4 v7, 0x0

    invoke-virtual {v3, v7, v6, v7, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 86
    const-string v5, "number"

    const-string v6, ""

    invoke-virtual {v1, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 87
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_31

    .line 88
    const-string v5, "unica_ca_log_unknown"

    invoke-direct {v0, v5}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 90
    :cond_31
    const-string v8, "durationMs"

    const-wide/16 v9, 0x0

    invoke-virtual {v1, v8, v9, v10}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v11

    .line 91
    new-instance v8, Ljava/text/SimpleDateFormat;

    const-string v13, "yyyy-MM-dd HH:mm"

    sget-object v14, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v8, v13, v14}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v13, Ljava/util/Date;

    .line 92
    const-string v14, "startedAt"

    invoke-virtual {v1, v14, v9, v10}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v9

    invoke-direct {v13, v9, v10}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {v8, v13}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v8

    .line 94
    new-instance v9, Landroid/widget/TextView;

    invoke-direct {v9, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 95
    const/high16 v10, 0x41880000    # 17.0f

    const/4 v13, 0x2

    invoke-virtual {v9, v13, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 96
    const-wide/32 v14, 0xea60

    div-long v14, v11, v14

    sget-object v10, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-wide/16 v16, 0x3e8

    div-long v11, v11, v16

    const-wide/16 v16, 0x3c

    rem-long v11, v11, v16

    .line 97
    invoke-static {v11, v12}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v11

    filled-new-array {v11}, [Ljava/lang/Object;

    move-result-object v11

    const-string v12, "%02d"

    invoke-static {v10, v12, v11}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v10

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v11, "   \u2022   "

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v14, v15}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v8, ":"

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 96
    invoke-virtual {v9, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 98
    invoke-virtual {v3, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 100
    const-string v5, "summary"

    invoke-virtual {v1, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 101
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_d2

    .line 102
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 103
    const/high16 v8, 0x41600000    # 14.0f

    invoke-virtual {v6, v13, v8}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 104
    const v8, -0x777778

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setTextColor(I)V

    .line 105
    const/4 v8, 0x4

    invoke-direct {v0, v8}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v8

    invoke-virtual {v6, v7, v8, v7, v7}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 106
    invoke-virtual {v6, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 107
    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 110
    :cond_d2
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 111
    invoke-virtual {v5, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 112
    const/4 v6, 0x6

    invoke-direct {v0, v6}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v6

    invoke-virtual {v5, v7, v6, v7, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 113
    const-string v6, "unica_ca_play"

    invoke-direct {v0, v6}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "\u25b6  "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    new-instance v7, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;

    invoke-direct {v7, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;-><init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Lorg/json/JSONObject;)V

    invoke-direct {v0, v6, v7}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->button(Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 119
    const-string v1, "unica_ca_summarize"

    invoke-direct {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v6, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;

    invoke-direct {v6, v0, v2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;-><init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V

    invoke-direct {v0, v1, v6}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->button(Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 125
    const-string v1, "unica_ca_delete"

    invoke-direct {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v6, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$3;

    invoke-direct {v6, v0, v2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$3;-><init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V

    invoke-direct {v0, v1, v6}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->button(Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 131
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 133
    new-instance v1, Landroid/view/View;

    invoke-direct {v1, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 134
    const-string v2, "#33888888"

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/view/View;->setBackgroundColor(I)V

    .line 135
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    .line 136
    invoke-direct {v0, v4}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v0

    const/4 v4, -0x1

    invoke-direct {v2, v4, v0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 135
    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 137
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 138
    return-object v3
.end method

.method private static le32([BII)V
    .registers 5

    .line 311
    and-int/lit16 v0, p2, 0xff

    int-to-byte v0, v0

    aput-byte v0, p0, p1

    .line 312
    add-int/lit8 v0, p1, 0x1

    shr-int/lit8 v1, p2, 0x8

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 313
    add-int/lit8 v0, p1, 0x2

    shr-int/lit8 v1, p2, 0x10

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, p0, v0

    .line 314
    add-int/lit8 p1, p1, 0x3

    shr-int/lit8 p2, p2, 0x18

    and-int/lit16 p2, p2, 0xff

    int-to-byte p2, p2

    aput-byte p2, p0, p1

    .line 315
    return-void
.end method

.method private play(Ljava/lang/String;)V
    .registers 5

    .line 153
    new-instance v0, Ljava/io/File;

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 154
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    const-string v1, "unica_ca_log_missing"

    if-nez p1, :cond_55

    invoke-virtual {v0}, Ljava/io/File;->isFile()Z

    move-result p1

    if-nez p1, :cond_18

    goto :goto_55

    .line 158
    :cond_18
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->stopPlayer()V

    .line 160
    :try_start_1b
    new-instance p1, Landroid/media/MediaPlayer;

    invoke-direct {p1}, Landroid/media/MediaPlayer;-><init>()V

    .line 161
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->setDataSource(Ljava/lang/String;)V

    .line 162
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->prepare()V

    .line 163
    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V

    .line 164
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mPlayer:Landroid/media/MediaPlayer;
    :try_end_2f
    .catch Ljava/lang/Exception; {:try_start_1b .. :try_end_2f} :catch_30

    .line 168
    goto :goto_54

    .line 165
    :catch_30
    move-exception p1

    .line 166
    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "playback failed: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "UnicaCallAi"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 167
    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->toast(Ljava/lang/String;)V

    .line 169
    :goto_54
    return-void

    .line 155
    :cond_55
    :goto_55
    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->toast(Ljava/lang/String;)V

    .line 156
    return-void
.end method

.method private post(Ljava/lang/String;Z)V
    .registers 4

    .line 318
    new-instance v0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;

    invoke-direct {v0, p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;-><init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 327
    return-void
.end method

.method private static readCapped(Ljava/io/File;)[B
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 290
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-nez v0, :cond_8

    .line 291
    const/4 p0, 0x0

    return-object p0

    .line 293
    :cond_8
    new-instance v0, Ljava/io/RandomAccessFile;

    const-string v1, "r"

    invoke-direct {v0, p0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 295
    :try_start_f
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v1

    const-wide/32 v3, 0x124f82c

    invoke-static {v1, v2, v3, v4}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    long-to-int p0, v1

    .line 296
    new-array v1, p0, [B

    .line 297
    invoke-virtual {v0, v1}, Ljava/io/RandomAccessFile;->readFully([B)V

    .line 298
    int-to-long v2, p0

    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v4

    cmp-long v2, v2, v4

    if-gez v2, :cond_36

    .line 300
    add-int/lit8 p0, p0, -0x2c

    .line 301
    add-int/lit8 v2, p0, 0x24

    const/4 v3, 0x4

    invoke-static {v1, v3, v2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->le32([BII)V

    .line 302
    const/16 v2, 0x28

    invoke-static {v1, v2, p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->le32([BII)V
    :try_end_36
    .catchall {:try_start_f .. :try_end_36} :catchall_3b

    .line 304
    :cond_36
    nop

    .line 306
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V

    .line 304
    return-object v1

    .line 306
    :catchall_3b
    move-exception p0

    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V

    .line 307
    throw p0
.end method

.method private reload()V
    .registers 5

    .line 62
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 63
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object v0

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallRecorder;->readIndex(Ljava/io/File;)Lorg/json/JSONArray;

    move-result-object v0

    .line 64
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_3c

    .line 65
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 66
    const-string v1, "unica_ca_log_empty"

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 67
    const/4 v1, 0x2

    const/high16 v3, 0x41700000    # 15.0f

    invoke-virtual {v0, v1, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 68
    const/16 v1, 0x11

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setGravity(I)V

    .line 69
    const/16 v1, 0x30

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result v1

    invoke-virtual {v0, v2, v1, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 70
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 71
    return-void

    .line 73
    :cond_3c
    nop

    :goto_3d
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-ge v2, v1, :cond_55

    .line 74
    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v1

    .line 75
    if-eqz v1, :cond_52

    .line 76
    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    invoke-direct {p0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->entry(Lorg/json/JSONObject;I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 73
    :cond_52
    add-int/lit8 v2, v2, 0x1

    goto :goto_3d

    .line 79
    :cond_55
    return-void
.end method

.method private stopPlayer()V
    .registers 3

    .line 172
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mPlayer:Landroid/media/MediaPlayer;

    .line 173
    const/4 v1, 0x0

    iput-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mPlayer:Landroid/media/MediaPlayer;

    .line 174
    if-eqz v0, :cond_f

    .line 176
    :try_start_7
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->stop()V

    .line 177
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->release()V
    :try_end_d
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_d} :catch_e

    .line 179
    goto :goto_f

    .line 178
    :catch_e
    move-exception v0

    .line 181
    :cond_f
    :goto_f
    return-void
.end method

.method private str(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 336
    const-string v0, "string"

    invoke-static {v0, p1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 337
    if-nez p1, :cond_b

    const-string p1, ""

    goto :goto_f

    :cond_b
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->getString(I)Ljava/lang/String;

    move-result-object p1

    :goto_f
    return-object p1
.end method

.method private summarize(I)V
    .registers 5

    .line 203
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mBusy:Z

    if-eqz v0, :cond_5

    .line 204
    return-void

    .line 206
    :cond_5
    const-string v0, "unica_ca_gemini_key"

    const-string v1, ""

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 207
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1d

    .line 208
    const-string p1, "unica_ca_voice_no_key"

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->toast(Ljava/lang/String;)V

    .line 209
    return-void

    .line 211
    :cond_1d
    const/4 v1, 0x1

    iput-boolean v1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mBusy:Z

    .line 212
    const-string v1, "unica_ca_summarizing"

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->toast(Ljava/lang/String;)V

    .line 213
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;

    invoke-direct {v2, p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;-><init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;ILjava/lang/String;)V

    const-string p1, "unica-callai-summary"

    invoke-direct {v1, v2, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 236
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 237
    return-void
.end method

.method private toast(Ljava/lang/String;)V
    .registers 3

    .line 330
    if-eqz p1, :cond_10

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_10

    .line 331
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 333
    :cond_10
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .registers 6

    .line 48
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 49
    const-string p1, "unica_ca_log_title"

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->setTitle(Ljava/lang/CharSequence;)V

    .line 50
    new-instance p1, Landroid/widget/LinearLayout;

    invoke-direct {p1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    .line 51
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 52
    const/16 p1, 0x10

    invoke-direct {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->dp(I)I

    move-result p1

    .line 53
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p1, p1, p1, p1}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 54
    new-instance p1, Landroid/widget/ScrollView;

    invoke-direct {p1, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 55
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->mList:Landroid/widget/LinearLayout;

    new-instance v1, Landroid/view/ViewGroup$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {p1, v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 57
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->setContentView(Landroid/view/View;)V

    .line 58
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->reload()V

    .line 59
    return-void
.end method

.method protected onStop()V
    .registers 1

    .line 346
    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    .line 347
    invoke-direct {p0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->stopPlayer()V

    .line 348
    return-void
.end method
