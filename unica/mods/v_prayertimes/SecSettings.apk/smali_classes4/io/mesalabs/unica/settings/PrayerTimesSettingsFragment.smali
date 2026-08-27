.class public Lio/mesalabs/unica/settings/PrayerTimesSettingsFragment;
.super Lcom/android/settings/dashboard/DashboardFragment;
.source "PrayerTimesSettingsFragment.java"

# static fields
.field public static final SEARCH_INDEX_DATA_PROVIDER:Lcom/android/settings/search/BaseSearchIndexProvider;

# direct methods
.method public static constructor <clinit>()V
    .locals 3

    new-instance v0, Lcom/android/settings/search/BaseSearchIndexProvider;

    const-string v1, "xml"

    const-string v2, "unica_prayer_times_settings"

    invoke-static {v1, v2}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-direct {v0, v1}, Lcom/android/settings/search/BaseSearchIndexProvider;-><init>(I)V

    sput-object v0, Lio/mesalabs/unica/settings/PrayerTimesSettingsFragment;->SEARCH_INDEX_DATA_PROVIDER:Lcom/android/settings/search/BaseSearchIndexProvider;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Lcom/android/settings/dashboard/DashboardFragment;-><init>()V

    return-void
.end method

# virtual methods
.method public final getLogTag()Ljava/lang/String;
    .locals 1

    const-string v0, "PrayerTimesSettingsFragment"

    return-object v0
.end method

.method public final getMetricsCategory()I
    .locals 1

    const/16 v0, 0x2e9

    return v0
.end method

.method public final getPreferenceScreenResId()I
    .locals 2

    const-string v0, "xml"

    const-string v1, "unica_prayer_times_settings"

    invoke-static {v0, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    return v0
.end method
