.class Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;
.super Ljava/lang/Object;
.source "CallAiVoiceActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->row(I)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

.field final synthetic val$index:I


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 105
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iput p2, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 3

    .line 108
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;->this$0:Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;

    iget v0, p0, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity$2;->val$index:I

    invoke-static {p1, v0}, Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;->-$$Nest$mpreview(Lio/mesalabs/unica/settings/callai/CallAiVoiceActivity;I)V

    .line 109
    return-void
.end method
