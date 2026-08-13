.class public Lio/mesalabs/unica/settings/downloader/DownloaderLastUpdatePreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "DownloaderLastUpdatePreferenceController.java"

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

.method public getSummary()Ljava/lang/CharSequence;
    .locals 6
    iget-object v0, p0, Lcom/android/settingslib/core/AbstractPreferenceController;->mContext:Landroid/content/Context;
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v0
    const-string v1, "unica_dl_last_update_check"
    const-wide/16 v2, 0x0
    invoke-static {v0, v1, v2, v3}, Landroid/provider/Settings$System;->getLong(Landroid/content/ContentResolver;Ljava/lang/String;J)J
    move-result-wide v0
    cmp-long v2, v0, v2
    if-nez v2, :cond_0
    const-string v0, "Never"
    return-object v0
    :cond_0
    new-instance v2, Ljava/util/Date;
    invoke-direct {v2, v0, v1}, Ljava/util/Date;-><init>(J)V
    invoke-static {}, Ljava/text/DateFormat;->getDateTimeInstance()Ljava/text/DateFormat;
    move-result-object v0
    invoke-virtual {v0, v2}, Ljava/text/DateFormat;->format(Ljava/util/Date;)Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method
