.class public Lio/mesalabs/unica/settings/prayertimes/PrayerTimesCountdownPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "PrayerTimesCountdownPreferenceController.java"

.field private mPreference:Landroidx/preference/Preference;

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
    move-result-object p1
    iput-object p1, p0, Lio/mesalabs/unica/settings/prayertimes/PrayerTimesCountdownPreferenceController;->mPreference:Landroidx/preference/Preference;
    if-eqz p1, :cond_0
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "unica_prayer_times_city"
    invoke-static {v0, v1}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-nez v1, :cond_0
    iget-object v1, p0, Lio/mesalabs/unica/settings/prayertimes/PrayerTimesCountdownPreferenceController;->mPreference:Landroidx/preference/Preference;
    invoke-virtual {v1, v0}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V
    :cond_0
    return-void
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
    return-object v0
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