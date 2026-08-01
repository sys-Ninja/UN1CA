.class public Lio/mesalabs/unica/settings/callai/LiveModelPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;
.source "LiveModelPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 14
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 15
    return-void
.end method


# virtual methods
.method public emptyLabelResource()Ljava/lang/String;
    .registers 2

    .line 24
    const-string v0, "unica_ca_live_model_default"

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 19
    const-string v0, "unica_ca_live_model"

    return-object v0
.end method
