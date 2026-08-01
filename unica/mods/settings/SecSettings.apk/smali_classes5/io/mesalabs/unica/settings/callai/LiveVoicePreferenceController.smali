.class public Lio/mesalabs/unica/settings/callai/LiveVoicePreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "LiveVoicePreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 15
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 16
    return-void
.end method


# virtual methods
.method public defaultValue()Ljava/lang/String;
    .registers 2

    .line 25
    const-string v0, "Kore"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 13

    .line 38
    const-string v10, "unica_ca_voice_algieba"

    const-string v11, "unica_ca_voice_sadaltager"

    const-string v0, "unica_ca_voice_kore"

    const-string v1, "unica_ca_voice_zephyr"

    const-string v2, "unica_ca_voice_leda"

    const-string v3, "unica_ca_voice_aoede"

    const-string v4, "unica_ca_voice_sulafat"

    const-string v5, "unica_ca_voice_achernar"

    const-string v6, "unica_ca_voice_puck"

    const-string v7, "unica_ca_voice_charon"

    const-string v8, "unica_ca_voice_orus"

    const-string v9, "unica_ca_voice_fenrir"

    filled-new-array/range {v0 .. v11}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 20
    const-string v0, "unica_ca_live_voice"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 13

    .line 30
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

    return-object v0
.end method
