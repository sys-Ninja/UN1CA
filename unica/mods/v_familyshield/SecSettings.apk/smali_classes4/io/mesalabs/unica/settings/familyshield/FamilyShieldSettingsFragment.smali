.class public Lio/mesalabs/unica/settings/familyshield/FamilyShieldSettingsFragment;
.super Lcom/android/settings/dashboard/DashboardFragment;
.source "FamilyShieldSettingsFragment.java"

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Lcom/android/settings/dashboard/DashboardFragment;-><init>()V
    return-void
.end method

.method public getLogTag()Ljava/lang/String;
    .locals 1
    const-string v0, "FamilyShieldSettingsFragment"
    return-object v0
.end method

.method public getMetricsCategory()I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public getPreferenceScreenResId()I
    .locals 2
    const-string v0, "xml"
    const-string v1, "unica_family_shield_settings"
    invoke-static {v0, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method