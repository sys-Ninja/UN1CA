.class Lio/mesalabs/unica/settings/callai/TtsEngine$1;
.super Landroid/speech/tts/UtteranceProgressListener;
.source "TtsEngine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lio/mesalabs/unica/settings/callai/TtsEngine;->local(Ljava/lang/String;)[S
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lio/mesalabs/unica/settings/callai/TtsEngine;

.field final synthetic val$done:Ljava/util/concurrent/CountDownLatch;

.field final synthetic val$failed:[Z


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;[Z)V
    .registers 4

    .line 99
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->this$0:Lio/mesalabs/unica/settings/callai/TtsEngine;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->val$done:Ljava/util/concurrent/CountDownLatch;

    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->val$failed:[Z

    invoke-direct {p0}, Landroid/speech/tts/UtteranceProgressListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onDone(Ljava/lang/String;)V
    .registers 2

    .line 107
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->val$done:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 108
    return-void
.end method

.method public onError(Ljava/lang/String;)V
    .registers 4

    .line 112
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->val$failed:[Z

    const/4 v0, 0x0

    const/4 v1, 0x1

    aput-boolean v1, p1, v0

    .line 113
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$1;->val$done:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 114
    return-void
.end method

.method public onStart(Ljava/lang/String;)V
    .registers 2

    .line 103
    return-void
.end method
