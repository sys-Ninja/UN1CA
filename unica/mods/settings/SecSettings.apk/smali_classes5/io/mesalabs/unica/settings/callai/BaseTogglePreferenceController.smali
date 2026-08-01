.class public abstract Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;
.super Lcom/android/settings/core/TogglePreferenceController;
.source "BaseTogglePreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 10
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/TogglePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 11
    return-void
.end method


# virtual methods
.method public defaultValue()Z
    .registers 2

    .line 16
    const/4 v0, 0x0

    return v0
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 32
    const/4 v0, 0x0

    return v0
.end method

.method public isChecked()Z
    .registers 4

    .line 21
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->defaultValue()Z

    move-result v2

    invoke-static {v0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->getBoolean(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public setChecked(Z)Z
    .registers 4

    .line 26
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1, p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->putBoolean(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 27
    const/4 p1, 0x1

    return p1
.end method

.method public abstract settingKey()Ljava/lang/String;
.end method
