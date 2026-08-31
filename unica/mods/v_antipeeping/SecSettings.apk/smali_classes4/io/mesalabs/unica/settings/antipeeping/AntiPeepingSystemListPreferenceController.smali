.class public Lio/mesalabs/unica/settings/antipeeping/AntiPeepingSystemListPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "AntiPeepingSystemListPreferenceController.java"
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;

.field private mPreference:Landroidx/preference/ListPreference;

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

.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .locals 3
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;
    move-result-object v0
    check-cast v0, Landroidx/preference/ListPreference;
    iput-object v0, p0, Lio/mesalabs/unica/settings/antipeeping/AntiPeepingSystemListPreferenceController;->mPreference:Landroidx/preference/ListPreference;
    if-eqz v0, :cond_1
    iget-object v1, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v1
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v2
    invoke-static {v1, v2}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :cond_0
    invoke-virtual {v0, v1}, Landroidx/preference/ListPreference;->setValue(Ljava/lang/String;)V
    :cond_0
    iget-object v0, p0, Lio/mesalabs/unica/settings/antipeeping/AntiPeepingSystemListPreferenceController;->mPreference:Landroidx/preference/ListPreference;
    invoke-virtual {v0}, Landroidx/preference/ListPreference;->getEntry()Ljava/lang/CharSequence;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V
    :cond_1
    return-void
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .locals 3
    check-cast p2, Ljava/lang/String;
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    invoke-virtual {p0}, Lcom/android/settings/core/BasePreferenceController;->getPreferenceKey()Ljava/lang/String;
    move-result-object v1
    invoke-static {v0, v1, p2}, Landroid/provider/Settings$System;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z
    iget-object v0, p0, Lio/mesalabs/unica/settings/antipeeping/AntiPeepingSystemListPreferenceController;->mPreference:Landroidx/preference/ListPreference;
    invoke-virtual {v0, p2}, Landroidx/preference/ListPreference;->setValue(Ljava/lang/String;)V
    iget-object v0, p0, Lio/mesalabs/unica/settings/antipeeping/AntiPeepingSystemListPreferenceController;->mPreference:Landroidx/preference/ListPreference;
    invoke-virtual {v0}, Landroidx/preference/ListPreference;->getEntry()Ljava/lang/CharSequence;
    move-result-object p2
    invoke-virtual {v0, p2}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V
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
    return-object v0
.end method

.method public bridge synthetic ignoreUserInteraction()V
    .locals 0
    return-void
.end method

.method public bridge synthetic isControllable()Z
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic isPublicSlice()Z
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic isSliceable()Z
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic runDefaultAction()Z
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic useDynamicSliceSummary()Z
    .locals 1
    const/4 v0, 0x0
    return-object v0
.end method