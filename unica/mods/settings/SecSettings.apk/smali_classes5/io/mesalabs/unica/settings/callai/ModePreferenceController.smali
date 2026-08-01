.class public Lio/mesalabs/unica/settings/callai/ModePreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "ModePreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 13
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 14
    return-void
.end method


# virtual methods
.method public defaultValue()Ljava/lang/String;
    .registers 2

    .line 23
    const-string v0, "classic"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 3

    .line 33
    const-string v0, "unica_ca_mode_classic"

    const-string v1, "unica_ca_mode_live"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public onValueChanged(Ljava/lang/String;)V
    .registers 4

    .line 40
    const-string v0, "live"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_11

    .line 41
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModePreferenceController;->mContext:Landroid/content/Context;

    const-string v0, "unica_ca_provider"

    const-string v1, "gemini"

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 43
    :cond_11
    return-void
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 18
    const-string v0, "unica_ca_mode"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 3

    .line 28
    const-string v0, "classic"

    const-string v1, "live"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
