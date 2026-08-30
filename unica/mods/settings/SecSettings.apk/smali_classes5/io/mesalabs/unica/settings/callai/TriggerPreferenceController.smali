.class public Lio/mesalabs/unica/settings/callai/TriggerPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "TriggerPreferenceController.java"


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
    const-string v0, "all"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 4

    .line 11
    const-string v0, "unica_ca_trigger_unknown"

    const-string v1, "unica_ca_trigger_all"

    const-string v2, "unica_ca_trigger_manual"

    filled-new-array {v2, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 5
    const-string v0, "unica_ca_trigger"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 4

    .line 8
    const-string v0, "unknown"

    const-string v1, "all"

    const-string v2, "manual"

    filled-new-array {v2, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
