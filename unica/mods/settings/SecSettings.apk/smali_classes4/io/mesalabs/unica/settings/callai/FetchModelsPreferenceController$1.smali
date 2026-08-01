.class Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;
.super Ljava/lang/Object;
.source "FetchModelsPreferenceController.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->onPreferenceClick(Landroidx/preference/Preference;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;

.field final synthetic val$key:Ljava/lang/String;

.field final synthetic val$provider:Ljava/lang/String;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 66
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->this$0:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->val$provider:Ljava/lang/String;

    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 69
    nop

    .line 71
    :try_start_1
    const-string v0, "deepseek"

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->val$provider:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_12

    .line 72
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->val$key:Ljava/lang/String;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->fetchDeepSeek(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    goto :goto_18

    .line 73
    :cond_12
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->val$key:Ljava/lang/String;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->fetchGemini(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0
    :try_end_18
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_18} :catch_19

    .line 76
    :goto_18
    goto :goto_1b

    .line 74
    :catch_19
    move-exception v0

    .line 75
    const/4 v0, 0x0

    .line 77
    :goto_1b
    nop

    .line 78
    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->this$0:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;

    iget-object v1, v1, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->mHandler:Landroid/os/Handler;

    new-instance v2, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;

    invoke-direct {v2, p0, v0}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;-><init>(Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;Ljava/util/List;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 84
    return-void
.end method
