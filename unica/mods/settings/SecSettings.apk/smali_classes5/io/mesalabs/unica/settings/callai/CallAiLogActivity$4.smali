.class Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;
.super Ljava/lang/Object;
.source "CallAiLogActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->summarize(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

.field final synthetic val$index:I

.field final synthetic val$key:Ljava/lang/String;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;ILjava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 213
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iput p2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->val$index:I

    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 8

    .line 217
    const-string v0, "unica_ca_summary_failed"

    const/4 v1, 0x0

    :try_start_3
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->dir(Landroid/content/Context;)Ljava/io/File;

    move-result-object v2

    .line 218
    invoke-static {v2}, Lio/mesalabs/unica/settings/callai/CallRecorder;->readIndex(Ljava/io/File;)Lorg/json/JSONArray;

    move-result-object v3

    .line 219
    iget v4, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->val$index:I

    invoke-virtual {v3, v4}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    .line 220
    iget-object v5, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget-object v6, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->val$key:Ljava/lang/String;

    invoke-static {v5, v6, v2, v4}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mask(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Ljava/io/File;Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object v5

    .line 221
    if-eqz v5, :cond_39

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_24

    goto :goto_39

    .line 225
    :cond_24
    const-string v6, "summary"

    invoke-virtual {v4, v6, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 226
    iget v5, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->val$index:I

    invoke-virtual {v3, v5, v4}, Lorg/json/JSONArray;->put(ILjava/lang/Object;)Lorg/json/JSONArray;

    .line 227
    invoke-static {v2, v3}, Lio/mesalabs/unica/settings/callai/CallRecorder;->writeIndex(Ljava/io/File;Lorg/json/JSONArray;)V

    .line 228
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-static {v2, v3, v4}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V

    goto :goto_74

    .line 222
    :cond_39
    :goto_39
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v3, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V
    :try_end_44
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_44} :catch_4c
    .catchall {:try_start_3 .. :try_end_44} :catchall_4a

    .line 233
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Z)V

    .line 223
    return-void

    .line 233
    :catchall_4a
    move-exception v0

    goto :goto_7b

    .line 229
    :catch_4c
    move-exception v2

    .line 230
    :try_start_4d
    const-string v3, "UnicaCallAi"

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "summarize failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 231
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v3, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V
    :try_end_74
    .catchall {:try_start_4d .. :try_end_74} :catchall_4a

    .line 233
    :goto_74
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Z)V

    .line 234
    nop

    .line 235
    return-void

    .line 233
    :goto_7b
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v2, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Z)V

    .line 234
    throw v0
.end method
