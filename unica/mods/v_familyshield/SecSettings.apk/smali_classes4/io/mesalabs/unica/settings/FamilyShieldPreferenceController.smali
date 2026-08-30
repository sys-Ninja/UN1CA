.class public Lio/mesalabs/unica/settings/FamilyShieldPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "FamilyShieldPreferenceController.java"

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    return-void
.end method

.method public getAvailabilityStatus()I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic getBackgroundWorkerClass()Ljava/lang/Class;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public getBackupKeys()Ljava/util/List;
    .locals 1
    new-instance v0, Ljava/util/ArrayList;
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V
    return-object v0
.end method

.method public bridge synthetic getIntentFilter()Landroid/content/IntentFilter;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic getLaunchIntent()Landroid/content/Intent;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic getSliceHighlightMenuRes()I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic getStatusText()Ljava/lang/String;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic getValue()Lcom/samsung/android/settings/cube/ControlValue;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic hasAsyncUpdate()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic ignoreUserInteraction()V
    .locals 0
    return-void
.end method

.method public bridge synthetic isControllable()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic isPublicSlice()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic isSliceable()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic runDefaultAction()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic useDynamicSliceSummary()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method