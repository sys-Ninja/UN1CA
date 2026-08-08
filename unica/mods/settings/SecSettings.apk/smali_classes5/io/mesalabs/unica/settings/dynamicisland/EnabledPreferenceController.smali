.class public Lio/mesalabs/unica/settings/dynamicisland/EnabledPreferenceController;
.super Lio/mesalabs/unica/settings/dynamicisland/BaseTogglePreferenceController;
.source "EnabledPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 4
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/dynamicisland/BaseTogglePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 5
    const-string v0, "unica_di_enabled"

    return-object v0
.end method
