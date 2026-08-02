.class public abstract Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "BaseListPreferenceController.java"

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


# virtual methods
.method public abstract defaultValue()Ljava/lang/String;
.end method

.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 8

    .line 44
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    .line 45
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    check-cast p1, Landroidx/preference/SecDropDownPreference;

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    .line 46
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    if-nez p1, :cond_14

    .line 47
    return-void

    .line 50
    :cond_14
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->labelResources()[Ljava/lang/String;

    move-result-object p1

    .line 51
    array-length v0, p1

    new-array v0, v0, [Ljava/lang/CharSequence;

    .line 52
    const/4 v1, 0x0

    move v2, v1

    :goto_1d
    array-length v3, p1

    if-ge v2, v3, :cond_33

    .line 53
    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mContext:Landroid/content/Context;

    const-string v4, "string"

    aget-object v5, p1, v2

    invoke-static {v4, v5}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v0, v2

    .line 52
    add-int/lit8 v2, v2, 0x1

    goto :goto_1d

    .line 55
    :cond_33
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    invoke-virtual {p1, v0}, Landroidx/preference/SecDropDownPreference;->setEntries([Ljava/lang/CharSequence;)V

    .line 57
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->values()[Ljava/lang/String;

    move-result-object p1

    .line 58
    array-length v0, p1

    new-array v0, v0, [Ljava/lang/CharSequence;

    .line 59
    nop

    :goto_40
    array-length v2, p1

    if-ge v1, v2, :cond_4a

    .line 60
    aget-object v2, p1, v1

    aput-object v2, v0, v1

    .line 59
    add-int/lit8 v1, v1, 0x1

    goto :goto_40

    .line 62
    :cond_4a
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    iput-object v0, p1, Landroidx/preference/ListPreference;->mEntryValues:[Ljava/lang/CharSequence;

    .line 64
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->defaultValue()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/SecDropDownPreference;->setValue(Ljava/lang/String;)V

    .line 65
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mPreference:Landroidx/preference/SecDropDownPreference;

    invoke-virtual {p1, p0}, Landroidx/preference/SecDropDownPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    .line 66
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 80
    const/4 v0, 0x0

    return v0
.end method

.method public getBackupKeys()Ljava/util/List;
    .registers 2

    .line 85
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0
.end method

.method public getLaunchIntent()Landroid/content/Intent;
    .registers 2

    .line 90
    const/4 v0, 0x0

    return-object v0
.end method

.method public getSliceHighlightMenuRes()I
    .registers 2

    .line 125
    const/4 v0, 0x0

    return v0
.end method

.method public getStatusText()Ljava/lang/String;
    .registers 2

    .line 95
    const/4 v0, 0x0

    return-object v0
.end method

.method public getValue()Lcom/samsung/android/settings/cube/ControlValue;
    .registers 2

    .line 100
    const/4 v0, 0x0

    return-object v0
.end method

.method public isControllable()Z
    .registers 2

    .line 105
    const/4 v0, 0x0

    return v0
.end method

.method public abstract labelResources()[Ljava/lang/String;
.end method

.method public needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .registers 2

    .line 110
    sget-object p1, Lcom/samsung/android/settings/cube/Controllable$ControllableType;->NO_INTERACTION:Lcom/samsung/android/settings/cube/Controllable$ControllableType;

    return-object p1
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 4

    .line 70
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v0

    check-cast p2, Ljava/lang/String;

    invoke-static {p1, v0, p2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 71
    invoke-virtual {p0, p2}, Lio/mesalabs/unica/settings/callai/BaseListPreferenceController;->onValueChanged(Ljava/lang/String;)V

    .line 72
    const/4 p1, 0x1

    return p1
.end method

.method public onValueChanged(Ljava/lang/String;)V
    .registers 2

    .line 76
    return-void
.end method

.method public runDefaultAction()Z
    .registers 2

    .line 115
    const/4 v0, 0x0

    return v0
.end method

.method public setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .registers 2

    .line 120
    const/4 p1, 0x0

    return-object p1
.end method

.method public abstract settingKey()Ljava/lang/String;
.end method

.method public abstract values()[Ljava/lang/String;
.end method
