.class public Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "FetchModelsPreferenceController.java"

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceClickListener;


# instance fields
.field public mHandler:Landroid/os/Handler;

.field public mPreference:Landroidx/preference/Preference;

.field public mScreen:Landroidx/preference/PreferenceScreen;


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 42
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 43
    new-instance p1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object p2

    invoke-direct {p1, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mHandler:Landroid/os/Handler;

    .line 44
    return-void
.end method

.method public static fetchDeepSeek(Ljava/lang/String;)Ljava/util/List;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 163
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Bearer "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "Authorization"

    const-string v1, "https://api.deepseek.com/models"

    invoke-static {v1, p0, v0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->httpGet(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 165
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p0, "data"

    invoke-virtual {v0, p0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 166
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 167
    if-nez p0, :cond_2e

    .line 168
    return-object v0

    .line 170
    :cond_2e
    const/4 v1, 0x0

    :goto_2f
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v1, v2, :cond_50

    .line 171
    invoke-virtual {p0, v1}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 172
    if-nez v2, :cond_3c

    .line 173
    goto :goto_4d

    .line 175
    :cond_3c
    const-string v3, "id"

    const-string v4, ""

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 176
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_4d

    .line 177
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 170
    :cond_4d
    :goto_4d
    add-int/lit8 v1, v1, 0x1

    goto :goto_2f

    .line 180
    :cond_50
    return-object v0
.end method

.method public static fetchGemini(Ljava/lang/String;)Ljava/util/List;
    .registers 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 123
    const-string v0, "https://generativelanguage.googleapis.com/v1beta/models?pageSize=200"

    const-string v1, "x-goog-api-key"

    invoke-static {v0, p0, v1}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->httpGet(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 126
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p0, "models"

    invoke-virtual {v0, p0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 127
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 128
    if-nez p0, :cond_1b

    .line 129
    return-object v0

    .line 131
    :cond_1b
    const/4 v1, 0x0

    :goto_1c
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-ge v1, v2, :cond_53

    .line 132
    invoke-virtual {p0, v1}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    .line 133
    if-nez v2, :cond_29

    .line 134
    goto :goto_50

    .line 136
    :cond_29
    const-string v3, "name"

    const-string v4, ""

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 137
    const-string v4, "models/"

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_41

    .line 138
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v3

    .line 141
    :cond_41
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_50

    invoke-static {v2}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->supportsGenerate(Lorg/json/JSONObject;)Z

    move-result v2

    if-eqz v2, :cond_50

    .line 142
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 131
    :cond_50
    :goto_50
    add-int/lit8 v1, v1, 0x1

    goto :goto_1c

    .line 145
    :cond_53
    return-object v0
.end method

.method public static httpGet(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 185
    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    .line 187
    :try_start_b
    const-string v0, "GET"

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 188
    const/16 v0, 0x2710

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 189
    const/16 v0, 0x3a98

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 190
    invoke-virtual {p0, p2, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 191
    const-string p1, "Accept"

    const-string p2, "application/json"

    invoke-virtual {p0, p1, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 192
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    const/16 p2, 0xc8

    if-eq p1, p2, :cond_32

    .line 193
    const-string p1, ""
    :try_end_2e
    .catchall {:try_start_b .. :try_end_2e} :catchall_60

    .line 206
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 193
    return-object p1

    .line 195
    :cond_32
    :try_start_32
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p1

    .line 196
    new-instance p2, Ljava/io/BufferedReader;

    new-instance v0, Ljava/io/InputStreamReader;

    const-string v1, "UTF-8"

    invoke-direct {v0, p1, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {p2, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 197
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    .line 198
    invoke-virtual {p2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    .line 199
    :goto_4b
    if-eqz v0, :cond_55

    .line 200
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 201
    invoke-virtual {p2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    goto :goto_4b

    .line 203
    :cond_55
    invoke-virtual {p2}, Ljava/io/BufferedReader;->close()V

    .line 204
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1
    :try_end_5c
    .catchall {:try_start_32 .. :try_end_5c} :catchall_60

    .line 206
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 204
    return-object p1

    .line 206
    :catchall_60
    move-exception p1

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 207
    throw p1
.end method

.method public static supportsGenerate(Lorg/json/JSONObject;)Z
    .registers 6

    .line 149
    const-string v0, "supportedGenerationMethods"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 150
    const/4 v0, 0x1

    if-nez p0, :cond_a

    .line 151
    return v0

    .line 153
    :cond_a
    const/4 v1, 0x0

    move v2, v1

    :goto_c
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_22

    .line 154
    const-string v3, "generateContent"

    invoke-virtual {p0, v2}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1f

    .line 155
    return v0

    .line 153
    :cond_1f
    add-int/lit8 v2, v2, 0x1

    goto :goto_c

    .line 158
    :cond_22
    return v1
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 3

    .line 48
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    .line 49
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mScreen:Landroidx/preference/PreferenceScreen;

    .line 50
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    .line 51
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    if-eqz p1, :cond_18

    .line 52
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    invoke-virtual {p1, p0}, Landroidx/preference/Preference;->setOnPreferenceClickListener(Landroidx/preference/Preference$OnPreferenceClickListener;)V

    .line 54
    :cond_18
    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 212
    const/4 v0, 0x0

    return v0
.end method

.method public getBackupKeys()Ljava/util/List;
    .registers 2

    .line 217
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0
.end method

.method public getLaunchIntent()Landroid/content/Intent;
    .registers 2

    .line 222
    const/4 v0, 0x0

    return-object v0
.end method

.method public getSliceHighlightMenuRes()I
    .registers 2

    .line 257
    const/4 v0, 0x0

    return v0
.end method

.method public getStatusText()Ljava/lang/String;
    .registers 2

    .line 227
    const/4 v0, 0x0

    return-object v0
.end method

.method public getValue()Lcom/samsung/android/settings/cube/ControlValue;
    .registers 2

    .line 232
    const/4 v0, 0x0

    return-object v0
.end method

.method public isControllable()Z
    .registers 2

    .line 237
    const/4 v0, 0x0

    return v0
.end method

.method public needUserInteraction(Ljava/lang/Object;)Lcom/samsung/android/settings/cube/Controllable$ControllableType;
    .registers 2

    .line 242
    sget-object p1, Lcom/samsung/android/settings/cube/Controllable$ControllableType;->NO_INTERACTION:Lcom/samsung/android/settings/cube/Controllable$ControllableType;

    return-object p1
.end method

.method public onFetched(Ljava/util/List;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 90
    if-eqz p1, :cond_7f

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_7f

    .line 94
    :cond_9
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 95
    const/4 v1, 0x0

    :goto_f
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_28

    .line 96
    if-lez v1, :cond_1c

    .line 97
    const/16 v2, 0x2c

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 99
    :cond_1c
    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 95
    add-int/lit8 v1, v1, 0x1

    goto :goto_f

    .line 101
    :cond_28
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    const-string v2, "unica_ca_model_list"

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v2, v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->put(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 103
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mScreen:Landroidx/preference/PreferenceScreen;

    if-eqz v0, :cond_46

    .line 104
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mScreen:Landroidx/preference/PreferenceScreen;

    .line 105
    const-string v1, "unica_ca_model"

    invoke-virtual {v0, v1}, Landroidx/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object v0

    check-cast v0, Landroidx/preference/SecDropDownPreference;

    .line 106
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {v1, v0}, Lio/mesalabs/unica/settings/callai/ModelPreferenceController;->populate(Landroid/content/Context;Landroidx/preference/SecDropDownPreference;)V

    .line 108
    :cond_46
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    if-eqz v0, :cond_7e

    .line 109
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    .line 110
    const-string v2, "string"

    const-string v3, "unica_ca_fetch_done"

    invoke-static {v2, v3}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    .line 109
    invoke-virtual {v1, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 111
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, ")"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 109
    invoke-virtual {v0, p1}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 113
    :cond_7e
    return-void

    .line 91
    :cond_7f
    :goto_7f
    const-string p1, "unica_ca_fetch_failed"

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->setSummaryResource(Ljava/lang/String;)V

    .line 92
    return-void
.end method

.method public onPreferenceClick(Landroidx/preference/Preference;)Z
    .registers 6

    .line 58
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->provider(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p1

    .line 59
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->activeKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 60
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_19

    .line 61
    const-string p1, "unica_ca_fetch_no_key"

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->setSummaryResource(Ljava/lang/String;)V

    .line 62
    return v2

    .line 64
    :cond_19
    const-string v1, "unica_ca_fetch_running"

    invoke-virtual {p0, v1}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->setSummaryResource(Ljava/lang/String;)V

    .line 66
    new-instance v1, Ljava/lang/Thread;

    new-instance v3, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;

    invoke-direct {v3, p0, p1, v0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;-><init>(Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v1, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 85
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 86
    return v2
.end method

.method public runDefaultAction()Z
    .registers 2

    .line 247
    const/4 v0, 0x0

    return v0
.end method

.method public setSummaryResource(Ljava/lang/String;)V
    .registers 5

    .line 116
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    if-eqz v0, :cond_15

    .line 117
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mPreference:Landroidx/preference/Preference;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mContext:Landroid/content/Context;

    const-string v2, "string"

    invoke-static {v2, p1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 119
    :cond_15
    return-void
.end method

.method public setValue(Lcom/samsung/android/settings/cube/ControlValue;)Lcom/samsung/android/settings/cube/ControlResult;
    .registers 2

    .line 252
    const/4 p1, 0x0

    return-object p1
.end method
