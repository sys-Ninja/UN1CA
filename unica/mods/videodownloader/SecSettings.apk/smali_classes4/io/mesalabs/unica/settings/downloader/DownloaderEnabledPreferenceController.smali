.class public Lio/mesalabs/unica/settings/downloader/DownloaderEnabledPreferenceController;
.super Lcom/android/settings/core/TogglePreferenceController;
.source "DownloaderEnabledPreferenceController.java"

# static fields
.field private static final PREFS_NAME:Ljava/lang/String; = "io.mesalabs.unica.downloader_preferences"
.field private static final KEY_ENABLED:Ljava/lang/String; = "enabled"

# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/TogglePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    return-void
.end method

# virtual methods
.method public getAvailabilityStatus()I
    .locals 0
    const/4 p0, 0x0
    return p0
.end method

.method public bridge synthetic getBackgroundWorkerClass()Ljava/lang/Class;
    .locals 0
    const/4 p0, 0x0
    return-object p0
.end method

.method public bridge synthetic getBackupKeys()Ljava/util/List;
    .locals 0
    invoke-super {p0}, Lcom/android/settings/core/TogglePreferenceController;->getBackupKeys()Ljava/util/List;
    move-result-object p0
    return-object p0
.end method

.method public bridge synthetic getIntentFilter()Landroid/content/IntentFilter;
    .locals 0
    const/4 p0, 0x0
    return-object p0
.end method

.method public bridge synthetic getLaunchIntent()Landroid/content/Intent;
    .locals 0
    invoke-super {p0}, Lcom/android/settings/core/TogglePreferenceController;->getLaunchIntent()Landroid/content/Intent;
    move-result-object p0
    return-object p0
.end method

.method public bridge synthetic getSliceHighlightMenuRes()I
    .locals 0
    const/4 p0, 0x0
    return p0
.end method

.method public bridge synthetic getStatusText()Ljava/lang/String;
    .locals 0
    invoke-super {p0}, Lcom/android/settings/core/TogglePreferenceController;->getStatusText()Ljava/lang/String;
    move-result-object p0
    return-object p0
.end method

.method public bridge synthetic hasAsyncUpdate()Z
    .locals 0
    const/4 p0, 0x0
    return p0
.end method

.method public bridge synthetic ignoreUserInteraction()V
    .locals 0
    invoke-super {p0}, Lcom/android/settings/core/TogglePreferenceController;->ignoreUserInteraction()V
    return-void
.end method

.method public isChecked()Z
    .locals 3
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    const-string v1, "io.mesalabs.unica.downloader_preferences"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v1, "enabled"
    const/4 v2, 0x1
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0
.end method

.method public isControllable()Z
    .locals 0
    const/4 p0, 0x1
    return p0
.end method

.method public bridge synthetic needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .locals 0
    invoke-super {p0, p1}, Lcom/android/settings/core/TogglePreferenceController;->needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    move-result-object p0
    return-object p0
.end method

.method public bridge synthetic runDefaultAction()Z
    .locals 0
    invoke-super {p0}, Lcom/android/settings/core/TogglePreferenceController;->runDefaultAction()Z
    move-result p0
    return p0
.end method

.method public setChecked(Z)Z
    .locals 3
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    const-string v1, "io.mesalabs.unica.downloader_preferences"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "enabled"
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    const/4 p0, 0x1
    return p0
.end method

.method public bridge synthetic useDynamicSliceSummary()Z
    .locals 0
    const/4 p0, 0x0
    return p0
.end method