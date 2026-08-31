.class public Lio/mesalabs/unica/settings/screentranslator/ScreenTranslatorSystemTogglePreferenceController;
.super Lcom/android/settings/core/TogglePreferenceController;
.source "ScreenTranslatorSystemTogglePreferenceController.java"

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
    const/4 v2, 0x0
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I
    move-result v0
    const/4 v1, 0x1
    if-ne v0, v1, :cond_0
    return v1
    :cond_0
    return v2
.end method

.method public setChecked(Z)Z
    .locals 6
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v1
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v2
    if-eqz p1, :cond_0
    const/4 p1, 0x1
    goto :goto_0
    :cond_0
    const/4 p1, 0x0
    :goto_0
    invoke-static {v1, v2, p1}, Landroid/provider/Settings$System;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    # If master service toggle and turning ON: Launch the app so user grants MediaProjection
    const-string v3, "unica_st_service_enabled"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :skip_launch
    if-eqz p1, :skip_launch

    # Launch ScreenTranslatorSettingsActivity
    new-instance v3, Landroid/content/Intent;
    const-string v4, "io.mesalabs.unica.action.SCREEN_TRANSLATOR_SETTINGS"
    invoke-direct {v3, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v4, "io.mesalabs.unica.screentranslator"
    invoke-virtual {v3, v4}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;
    const v4, 0x10000000
    invoke-virtual {v3, v4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-virtual {v0, v3}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    :skip_launch
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