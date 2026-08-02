.class Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;
.super Ljava/lang/Object;
.source "CallAiVoiceActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->post(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

.field final synthetic val$msg:Ljava/lang/String;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 285
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;->val$msg:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 288
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$4;->val$msg:Ljava/lang/String;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mtoast(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;Ljava/lang/String;)V

    .line 289
    return-void
.end method
