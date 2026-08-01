.class public abstract Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "BaseTextPreferenceController.java"

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;


# instance fields
.field public mPreference:Landroidx/preference/SecEditTextPreference;


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 29
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 30
    return-void
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 4

    .line 46
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    .line 47
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    check-cast p1, Landroidx/preference/SecEditTextPreference;

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    .line 48
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    if-nez p1, :cond_14

    .line 49
    return-void

    .line 51
    :cond_14
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v0

    const-string v1, ""

    invoke-static {p1, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 52
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    invoke-virtual {v0, p1}, Landroidx/preference/SecEditTextPreference;->setText(Ljava/lang/String;)V

    .line 53
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->summaryFor(Ljava/lang/String;)Ljava/lang/CharSequence;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroidx/preference/SecEditTextPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 54
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    invoke-virtual {p1, p0}, Landroidx/preference/SecEditTextPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    .line 55
    return-void
.end method

.method public emptyLabelResource()Ljava/lang/String;
    .registers 2

    .line 41
    const-string v0, "unica_ca_not_set"

    return-object v0
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 84
    const/4 v0, 0x0

    return v0
.end method

.method public getBackupKeys()Ljava/util/List;
    .registers 2

    .line 89
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0
.end method

.method public getLaunchIntent()Landroid/content/Intent;
    .registers 2

    .line 94
    const/4 v0, 0x0

    return-object v0
.end method

.method public getSliceHighlightMenuRes()I
    .registers 2

    .line 129
    const/4 v0, 0x0

    return v0
.end method

.method public getStatusText()Ljava/lang/String;
    .registers 2

    .line 99
    const/4 v0, 0x0

    return-object v0
.end method

.method public getValue()Lcom/samsung/android/settings/cube/ControlValue;
    .registers 2

    .line 104
    const/4 v0, 0x0

    return-object v0
.end method

.method public isControllable()Z
    .registers 2

    .line 109
    const/4 v0, 0x0

    return v0
.end method

.method public isSecret()Z
    .registers 2

    .line 36
    const/4 v0, 0x0

    return v0
.end method

.method public needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .registers 2

    .line 114
    sget-object p1, Lcom/samsung/android/settings/cube/Controllable$ControllableType;->NO_INTERACTION:Lcom/samsung/android/settings/cube/Controllable$ControllableType;

    return-object p1
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 4

    .line 59
    if-nez p2, :cond_5

    const-string p1, ""

    goto :goto_b

    :cond_5
    check-cast p2, Ljava/lang/String;

    invoke-virtual {p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 60
    :goto_b
    iget-object p2, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->settingKey()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0, p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 61
    iget-object p2, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mPreference:Landroidx/preference/SecEditTextPreference;

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->summaryFor(Ljava/lang/String;)Ljava/lang/CharSequence;

    move-result-object p1

    invoke-virtual {p2, p1}, Landroidx/preference/SecEditTextPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 62
    const/4 p1, 0x1

    return p1
.end method

.method public runDefaultAction()Z
    .registers 2

    .line 119
    const/4 v0, 0x0

    return v0
.end method

.method public setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .registers 2

    .line 124
    const/4 p1, 0x0

    return-object p1
.end method

.method public abstract settingKey()Ljava/lang/String;
.end method

.method public summaryFor(Ljava/lang/String;)Ljava/lang/CharSequence;
    .registers 6

    .line 66
    if-eqz p1, :cond_3f

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_3f

    .line 69
    :cond_9
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->isSecret()Z

    move-result v0

    if-nez v0, :cond_10

    .line 70
    return-object p1

    .line 73
    :cond_10
    const/4 v0, 0x4

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 74
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 75
    const/4 v2, 0x0

    :goto_1f
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v3

    sub-int/2addr v3, v0

    if-ge v2, v3, :cond_2e

    .line 76
    const/16 v3, 0x2022

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 75
    add-int/lit8 v2, v2, 0x1

    goto :goto_1f

    .line 78
    :cond_2e
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    sub-int/2addr v2, v0

    invoke-virtual {p1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 79
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 67
    :cond_3f
    :goto_3f
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->mContext:Landroid/content/Context;

    const-string v0, "string"

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/BaseTextPreferenceController;->emptyLabelResource()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method
