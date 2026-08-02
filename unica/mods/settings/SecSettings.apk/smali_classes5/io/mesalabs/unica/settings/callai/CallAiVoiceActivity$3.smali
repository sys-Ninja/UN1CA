.class Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;
.super Ljava/lang/Object;
.source "CallAiVoiceActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->preview(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

.field final synthetic val$index:I

.field final synthetic val$key:Ljava/lang/String;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;ILjava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 145
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iput p2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->val$index:I

    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 7

    .line 149
    const-string v0, "unica_ca_voice_failed"

    const/4 v1, 0x0

    :try_start_3
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    sget-object v3, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->VOICES:[Ljava/lang/String;

    iget v4, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->val$index:I

    aget-object v3, v3, v4

    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->val$key:Ljava/lang/String;

    invoke-static {v2, v3, v4}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$msample(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;Ljava/lang/String;)[S

    move-result-object v2

    .line 150
    if-nez v2, :cond_1f

    .line 151
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    invoke-static {v3, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V

    goto :goto_24

    .line 153
    :cond_1f
    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    invoke-static {v3, v2}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mplay(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;[S)V
    :try_end_24
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_24} :catch_2c
    .catchall {:try_start_3 .. :try_end_24} :catchall_2a

    .line 159
    :goto_24
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Z)V

    .line 160
    goto :goto_55

    .line 159
    :catchall_2a
    move-exception v0

    goto :goto_56

    .line 155
    :catch_2c
    move-exception v2

    .line 156
    :try_start_2d
    const-string v3, "UnicaCallAi"

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "voice preview failed: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 157
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    invoke-static {v3, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mstr(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mpost(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V
    :try_end_54
    .catchall {:try_start_2d .. :try_end_54} :catchall_2a

    goto :goto_24

    .line 161
    :goto_55
    return-void

    .line 159
    :goto_56
    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$3;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    invoke-static {v2, v1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$fputmBusy(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Z)V

    .line 160
    throw v0
.end method
