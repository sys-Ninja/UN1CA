.class public Lio/mesalabs/unica/settings/ghostengine/GhostCameraSettingsFragment;
.super Lcom/android/settings/dashboard/DashboardFragment;
.source "GhostCameraSettingsFragment.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Lcom/android/settings/dashboard/DashboardFragment;-><init>()V
    return-void
.end method

.method public final getLogTag()Ljava/lang/String;
    .locals 1
    const-string v0, "GhostCameraSettingsFragment"
    return-object v0
.end method

.method public final getMetricsCategory()I
    .locals 1
    const/16 v0, 0x2ea
    return v0
.end method

.method public final getPreferenceScreenResId()I
    .locals 2
    const-string v0, "xml"
    const-string v1, "unica_ghost_camera_settings"
    invoke-static {v0, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method