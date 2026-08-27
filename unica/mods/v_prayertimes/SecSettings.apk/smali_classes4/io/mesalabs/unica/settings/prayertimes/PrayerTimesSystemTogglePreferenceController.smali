.class public Lio/mesalabs/unica/settings/prayertimes/PrayerTimesSystemTogglePreferenceController;
.super Lcom/android/settings/core/TogglePreferenceController;
.source "TogglePreferenceController.java"

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/TogglePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    return-void
.end method

.method public getAvailabilityStatus()I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public isChecked()Z
    .locals 4
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v1
    const/4 v2, 0x1
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v0
    if-ne v0, v2, :cond_0
    goto :cond_1
    :cond_0
    const/4 v2, 0x0
    :cond_1
    return v2
.end method

.method public setChecked(Z)Z
    .locals 3
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v1
    if-eqz p1, :cond_0
    const/4 p1, 0x1
    goto :cond_1
    :cond_0
    const/4 p1, 0x0
    :cond_1
    invoke-static {v0, v1, p1}, Landroid/provider/Settings$System;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z
    const/4 v0, 0x1
    return v0
.end method

.method public bridge synthetic getBackgroundWorkerClass()Ljava/lang/Class;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method
.method public bridge synthetic getBackupKeys()Ljava/util/List;
    .locals 1
    const/4 v0, 0x0
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
    const/4 v0, 0x1
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
.method public bridge synthetic useDynamicSliceSummary()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method
