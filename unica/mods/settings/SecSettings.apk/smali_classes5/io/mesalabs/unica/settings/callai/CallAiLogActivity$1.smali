.class Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;
.super Ljava/lang/Object;
.source "CallAiLogActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->entry(Lorg/json/JSONObject;I)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

.field final synthetic val$o:Lorg/json/JSONObject;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Lorg/json/JSONObject;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 113
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;->val$o:Lorg/json/JSONObject;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    .line 116
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$1;->val$o:Lorg/json/JSONObject;

    const-string v1, "file"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$mplay(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;Ljava/lang/String;)V

    .line 117
    return-void
.end method
