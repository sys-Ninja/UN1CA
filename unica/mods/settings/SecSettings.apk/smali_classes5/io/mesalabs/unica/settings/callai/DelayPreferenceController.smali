.class public Lio/mesalabs/unica/settings/callai/DelayPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "DelayPreferenceController.java"


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
    const-string v0, "5"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 5

    .line 9
    const-string v0, "unica_ca_delay_10"

    const-string v1, "unica_ca_delay_20"

    const-string v2, "unica_ca_delay_0"

    const-string v3, "unica_ca_delay_5"

    filled-new-array {v2, v3, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 5
    const-string v0, "unica_ca_delay"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 5

    .line 7
    const-string v0, "10"

    const-string v1, "20"

    const-string v2, "0"

    const-string v3, "5"

    filled-new-array {v2, v3, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
