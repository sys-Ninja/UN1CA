.class public Lio/mesalabs/unica/settings/callai/GeminiKeyPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;
.source "GeminiKeyPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 8
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 9
    return-void
.end method


# virtual methods
.method public isSecret()Z
    .registers 2

    .line 18
    const/4 v0, 0x1

    return v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 13
    const-string v0, "unica_ca_gemini_key"

    return-object v0
.end method
