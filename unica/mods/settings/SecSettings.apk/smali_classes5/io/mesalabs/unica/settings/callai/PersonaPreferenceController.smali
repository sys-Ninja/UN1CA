.class public Lio/mesalabs/unica/settings/callai/PersonaPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;
.source "PersonaPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 9
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 10
    return-void
.end method


# virtual methods
.method public emptyLabelResource()Ljava/lang/String;
    .registers 2

    .line 19
    const-string v0, "unica_ca_persona_default"

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 14
    const-string v0, "unica_ca_persona"

    return-object v0
.end method
