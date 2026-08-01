.class public Lio/mesalabs/unica/settings/callai/ModelPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "ModelPreferenceController.java"

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;


# instance fields
.field public mPreference:Landroidx/preference/SecDropDownPreference;


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 29
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 30
    return-void
.end method

.method public static populate(Landroid/content/Context;Landroidx/preference/SecDropDownPreference;)V
    .registers 9

    .line 52
    if-nez p1, :cond_3

    .line 53
    return-void

    .line 55
    :cond_3
    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 56
    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->defaultModel(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 58
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 59
    const-string v2, "unica_ca_model_list"

    const-string v3, ""

    invoke-static {p0, v2, v3}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 60
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_41

    .line 61
    const-string v3, ","

    invoke-virtual {v2, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    .line 62
    move v3, v4

    :goto_26
    array-length v5, v2

    if-ge v3, v5, :cond_41

    .line 63
    aget-object v5, v2, v3

    invoke-virtual {v5}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v5

    .line 64
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_3e

    invoke-interface {v1, v5}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_3e

    .line 65
    invoke-interface {v1, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 62
    :cond_3e
    add-int/lit8 v3, v3, 0x1

    goto :goto_26

    .line 69
    :cond_41
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_4a

    .line 70
    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 73
    :cond_4a
    const-string v2, "unica_ca_model"

    invoke-static {p0, v2, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 75
    invoke-interface {v1, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_5f

    .line 76
    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 77
    invoke-static {p0, v2, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 80
    :cond_5f
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result p0

    new-array p0, p0, [Ljava/lang/CharSequence;

    .line 81
    nop

    :goto_66
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    if-ge v4, v2, :cond_77

    .line 82
    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    aput-object v2, p0, v4

    .line 81
    add-int/lit8 v4, v4, 0x1

    goto :goto_66

    .line 84
    :cond_77
    invoke-virtual {p1, p0}, Landroidx/preference/SecDropDownPreference;->setEntries([Ljava/lang/CharSequence;)V

    .line 85
    invoke-virtual {p1, p0}, Landroidx/preference/SecDropDownPreference;->setEntryValues([Ljava/lang/CharSequence;)V

    .line 86
    invoke-virtual {p1, v0}, Landroidx/preference/SecDropDownPreference;->setValue(Ljava/lang/String;)V

    .line 87
    invoke-virtual {p1, v0}, Landroidx/preference/SecDropDownPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 88
    return-void
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 3

    .line 34
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    .line 35
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    check-cast p1, Landroidx/preference/SecDropDownPreference;

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    .line 36
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    if-nez p1, :cond_14

    .line 37
    return-void

    .line 39
    :cond_14
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    invoke-virtual {p1, p0}, Landroidx/preference/SecDropDownPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    .line 40
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->refresh()V

    .line 41
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 105
    const/4 v0, 0x0

    return v0
.end method

.method public getBackupKeys()Ljava/util/List;
    .registers 2

    .line 110
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0
.end method

.method public getLaunchIntent()Landroid/content/Intent;
    .registers 2

    .line 115
    const/4 v0, 0x0

    return-object v0
.end method

.method public getSliceHighlightMenuRes()I
    .registers 2

    .line 150
    const/4 v0, 0x0

    return v0
.end method

.method public getStatusText()Ljava/lang/String;
    .registers 2

    .line 120
    const/4 v0, 0x0

    return-object v0
.end method

.method public getValue()Lcom/samsung/android/settings/cube/ControlValue;
    .registers 2

    .line 125
    const/4 v0, 0x0

    return-object v0
.end method

.method public isControllable()Z
    .registers 2

    .line 130
    const/4 v0, 0x0

    return v0
.end method

.method public needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .registers 2

    .line 135
    sget-object p1, Lcom/samsung/android/settings/cube/Controllable$ControllableType;->NO_INTERACTION:Lcom/samsung/android/settings/cube/Controllable$ControllableType;

    return-object p1
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 4

    .line 92
    check-cast p2, Ljava/lang/String;

    .line 93
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mContext:Landroid/content/Context;

    const-string v0, "unica_ca_model"

    invoke-static {p1, v0, p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 94
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    invoke-virtual {p1, p2}, Landroidx/preference/SecDropDownPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 96
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p1

    const-string v0, "deepseek"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_27

    .line 97
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mContext:Landroid/content/Context;

    .line 98
    invoke-static {p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->isThinkingModel(Ljava/lang/String;)Z

    move-result p2

    .line 97
    const-string v0, "unica_ca_thinking"

    invoke-static {p1, v0, p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->putBoolean(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 100
    :cond_27
    const/4 p1, 0x1

    return p1
.end method

.method public refresh()V
    .registers 3

    .line 44
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->populate(Landroid/content/Context;Landroidx/preference/SecDropDownPreference;)V

    .line 45
    return-void
.end method

.method public runDefaultAction()Z
    .registers 2

    .line 140
    const/4 v0, 0x0

    return v0
.end method

.method public setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .registers 2

    .line 145
    const/4 p1, 0x0

    return-object p1
.end method
