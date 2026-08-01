.class public Lio/mesalabs/unica/settings/callai/ThinkingPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;
.source "ThinkingPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 4
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public defaultValue()Z
    .registers 2

    .line 6
    const/4 v0, 0x0

    return v0
.end method

.method public setChecked(Z)Z
    .registers 4

    .line 12
    invoke-super {p0, p1}, Lio/mesalabs/unica/settings/callai/BaseTogglePreferenceController;->setChecked(Z)Z

    .line 13
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/ThinkingPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "deepseek"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1f

    .line 14
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/ThinkingPreferenceController;->mContext:Landroid/content/Context;

    .line 15
    if-eqz p1, :cond_18

    const-string p1, "deepseek-reasoner"

    goto :goto_1a

    :cond_18
    const-string p1, "deepseek-chat"

    .line 14
    :goto_1a
    const-string v1, "unica_ca_model"

    invoke-static {v0, v1, p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 17
    :cond_1f
    const/4 p1, 0x1

    return p1
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 5
    const-string v0, "unica_ca_thinking"

    return-object v0
.end method
