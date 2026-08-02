.class Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;
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

.field final synthetic val$index:I


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 119
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iput p2, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 3

    .line 122
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;->this$0:Lio/mesalabs/unica/settings/callai/CallAiLogActivity;

    iget v0, p0, Lio/mesalabs/unica/settings/callai/CallAiLogActivity$2;->val$index:I

    invoke-static {p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiLogActivity;->-$$Nest$msummarize(Lio/mesalabs/unica/settings/callai/CallAiLogActivity;I)V

    .line 123
    return-void
.end method
