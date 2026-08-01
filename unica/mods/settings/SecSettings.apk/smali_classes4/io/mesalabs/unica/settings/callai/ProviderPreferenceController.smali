.class public Lio/mesalabs/unica/settings/callai/ProviderPreferenceController;
.super Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.source "ProviderPreferenceController.java"


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 13
    invoke-direct {p0, p1, p2}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 14
    return-void
.end method


# virtual methods
.method public defaultValue()Ljava/lang/String;
    .registers 2

    .line 23
    const-string v0, "gemini"

    return-object v0
.end method

.method public labelResources()[Ljava/lang/String;
    .registers 3

    .line 33
    const-string v0, "unica_ca_provider_gemini"

    const-string v1, "unica_ca_provider_deepseek"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public onValueChanged(Ljava/lang/String;)V
    .registers 4

    .line 38
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/ProviderPreferenceController;->mContext:Landroid/content/Context;

    const-string v1, "unica_ca_model"

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->defaultModel(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, v1, p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 39
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ProviderPreferenceController;->mContext:Landroid/content/Context;

    const-string v0, "unica_ca_model_list"

    const-string v1, ""

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 40
    return-void
.end method

.method public settingKey()Ljava/lang/String;
    .registers 2

    .line 18
    const-string v0, "unica_ca_provider"

    return-object v0
.end method

.method public values()[Ljava/lang/String;
    .registers 3

    .line 28
    const-string v0, "gemini"

    const-string v1, "deepseek"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
