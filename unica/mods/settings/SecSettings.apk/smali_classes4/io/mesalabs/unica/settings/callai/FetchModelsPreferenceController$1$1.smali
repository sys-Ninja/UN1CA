.class Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;
.super Ljava/lang/Object;
.source "FetchModelsPreferenceController.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;

.field final synthetic val$result:Ljava/util/List;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;Ljava/util/List;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 78
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;->this$1:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;->val$result:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 81
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;->this$1:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;

    iget-object v0, v0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1;->this$0:Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController$1$1;->val$result:Ljava/util/List;

    invoke-virtual {v0, v1}, Lio/mesalabs/unica/settings/callai/FetchModelsPreferenceController;->onFetched(Ljava/util/List;)V

    .line 82
    return-void
.end method
