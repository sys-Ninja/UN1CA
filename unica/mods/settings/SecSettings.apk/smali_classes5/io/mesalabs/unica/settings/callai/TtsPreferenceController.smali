.class public Lio/mesalabs/unica/settings/callai/TtsPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "TtsPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 4
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public defaultValue()Ljava/lang/String;
    .registers 2

    .line 6
    const-string v0, "local"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 3

    .line 11
    const-string v0, "unica_ca_tts_local"

    const-string v1, "unica_ca_tts_eleven"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 5
    const-string v0, "unica_ca_tts"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 3

    .line 8
    const-string v0, "local"

    const-string v1, "elevenlabs"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
