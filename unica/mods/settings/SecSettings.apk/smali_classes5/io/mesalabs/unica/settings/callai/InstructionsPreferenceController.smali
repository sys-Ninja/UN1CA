.class public Lio/mesalabs/unica/settings/callai/InstructionsPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;
.source "InstructionsPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 12
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 13
    return-void
.end method


# virtual methods
.method public emptyLabelResource()Ljava/lang/String;
    .registers 2

    .line 22
    const-string v0, "unica_ca_instructions_summary"

    return-object v0
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 17
    const-string v0, "unica_ca_instructions"

    return-object v0
.end method
