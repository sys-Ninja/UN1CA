.class public final Lio/mesalabs/unica/settings/callai/CallAiConfig;
.super Ljava/lang/Object;
.source "CallAiConfig.java"


# static fields
.field public static final DEEPSEEK_KEY:Ljava/lang/String; = "unica_ca_deepseek_key"

.field public static final DELAY:Ljava/lang/String; = "unica_ca_delay"

.field public static final ELEVEN_KEY:Ljava/lang/String; = "unica_ca_eleven_key"

.field public static final ELEVEN_VOICE:Ljava/lang/String; = "unica_ca_eleven_voice"

.field public static final ENABLED:Ljava/lang/String; = "unica_ca_enabled"

.field public static final GEMINI_KEY:Ljava/lang/String; = "unica_ca_gemini_key"

.field public static final GREETING:Ljava/lang/String; = "unica_ca_greeting"

.field public static final LANGUAGE:Ljava/lang/String; = "unica_ca_language"

.field public static final MODEL:Ljava/lang/String; = "unica_ca_model"

.field public static final MODEL_LIST:Ljava/lang/String; = "unica_ca_model_list"

.field public static final PERSONA:Ljava/lang/String; = "unica_ca_persona"

.field public static final PROVIDER:Ljava/lang/String; = "unica_ca_provider"

.field public static final PROVIDER_DEEPSEEK:Ljava/lang/String; = "deepseek"

.field public static final PROVIDER_GEMINI:Ljava/lang/String; = "gemini"

.field public static final SESSION_PROP:Ljava/lang/String; = "persist.sys.unica.ca.session"

.field public static final STT:Ljava/lang/String; = "unica_ca_stt"

.field public static final STT_AUTO:Ljava/lang/String; = "auto"

.field public static final STT_LOCAL:Ljava/lang/String; = "local"

.field public static final STT_PROVIDER:Ljava/lang/String; = "provider"

.field public static final THINKING:Ljava/lang/String; = "unica_ca_thinking"

.field public static final TRIGGER:Ljava/lang/String; = "unica_ca_trigger"

.field public static final TRIGGER_ALL:Ljava/lang/String; = "all"

.field public static final TRIGGER_MANUAL:Ljava/lang/String; = "manual"

.field public static final TRIGGER_UNKNOWN:Ljava/lang/String; = "unknown"

.field public static final TTS:Ljava/lang/String; = "unica_ca_tts"

.field public static final TTS_ELEVEN:Ljava/lang/String; = "elevenlabs"

.field public static final TTS_LOCAL:Ljava/lang/String; = "local"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 50
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static activeKey(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    .line 81
    const-string v0, "deepseek"

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, ""

    if-eqz v0, :cond_15

    .line 82
    const-string v0, "unica_ca_deepseek_key"

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    goto :goto_1b

    .line 83
    :cond_15
    const-string v0, "unica_ca_gemini_key"

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 81
    :goto_1b
    return-object p0
.end method

.method public static defaultModel(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 91
    const-string v0, "deepseek"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_b

    const-string p0, "deepseek-chat"

    goto :goto_d

    :cond_b
    const-string p0, "gemini-2.5-flash"

    :goto_d
    return-object p0
.end method

.method public static get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 53
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 54
    invoke-static {p0, p1}, Landroid/provider/Settings$Global;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 55
    if-eqz p0, :cond_12

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_11

    goto :goto_12

    :cond_11
    move-object p2, p0

    :cond_12
    :goto_12
    return-object p2
.end method

.method public static getBoolean(Landroid/content/Context;Ljava/lang/String;Z)Z
    .registers 4

    .line 63
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 64
    if-nez p0, :cond_8

    goto :goto_c

    :cond_8
    invoke-static {p0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result p2

    :goto_c
    return p2
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .registers 3

    .line 72
    const-string v0, "unica_ca_enabled"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->getBoolean(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public static isThinkingModel(Ljava/lang/String;)Z
    .registers 2

    .line 104
    if-eqz p0, :cond_c

    const-string v0, "reasoner"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_c

    const/4 p0, 0x1

    goto :goto_d

    :cond_c
    const/4 p0, 0x0

    :goto_d
    return p0
.end method

.method public static provider(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    .line 76
    const-string v0, "unica_ca_provider"

    const-string v1, "gemini"

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    .line 59
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-static {p0, p1, p2}, Landroid/provider/Settings$Global;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z

    .line 60
    return-void
.end method

.method public static putBoolean(Landroid/content/Context;Ljava/lang/String;Z)V
    .registers 3

    .line 68
    invoke-static {p2}, Ljava/lang/Boolean;->toString(Z)Ljava/lang/String;

    move-result-object p2

    invoke-static {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 69
    return-void
.end method

.method public static supportsThinkingToggle(Ljava/lang/String;)Z
    .registers 1

    .line 100
    const/4 p0, 0x1

    return p0
.end method
