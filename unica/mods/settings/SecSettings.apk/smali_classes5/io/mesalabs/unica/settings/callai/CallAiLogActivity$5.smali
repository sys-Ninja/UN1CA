.class Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;
.super Ljava/lang/Object;
.source "CallAiLogActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->post(Ljava/lang/String;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

.field final synthetic val$msg:Ljava/lang/String;

.field final synthetic val$refresh:Z


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;Z)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 318
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->val$msg:Ljava/lang/String;

    iput-boolean p3, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->val$refresh:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 321
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->val$msg:Ljava/lang/String;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mtoast(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)V

    .line 322
    iget-boolean v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->val$refresh:Z

    if-eqz v0, :cond_10

    .line 323
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$5;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mreload(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;)V

    .line 325
    :cond_10
    return-void
.end method
