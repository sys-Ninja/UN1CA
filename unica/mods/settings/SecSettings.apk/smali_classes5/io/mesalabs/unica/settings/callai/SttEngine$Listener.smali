.class final Lio/mesalabs/unica/settings/callai/SttEngine$Listener;
.super Ljava/lang/Object;
.source "SttEngine.java"

# interfaces
.implements Landroid/speech/RecognitionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/callai/SttEngine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Listener"
.end annotation


# instance fields
.field private final mDone:Ljava/util/concurrent/CountDownLatch;

.field private final mResult:[Ljava/lang/String;


# direct methods
.method constructor <init>([Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;)V
    .registers 3

    .line 150
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 151
    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;->mResult:[Ljava/lang/String;

    .line 152
    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;->mDone:Ljava/util/concurrent/CountDownLatch;

    .line 153
    return-void
.end method


# virtual methods
.method public onBeginningOfSpeech()V
    .registers 1

    .line 172
    return-void
.end method

.method public onBufferReceived([B)V
    .registers 2

    .line 174
    return-void
.end method

.method public onEndOfSpeech()V
    .registers 1

    .line 175
    return-void
.end method

.method public onError(I)V
    .registers 4

    .line 167
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "local stt error "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "UnicaCallAi"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 168
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;->mDone:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 169
    return-void
.end method

.method public onEvent(ILandroid/os/Bundle;)V
    .registers 3

    .line 177
    return-void
.end method

.method public onPartialResults(Landroid/os/Bundle;)V
    .registers 2

    .line 176
    return-void
.end method

.method public onReadyForSpeech(Landroid/os/Bundle;)V
    .registers 2

    .line 171
    return-void
.end method

.method public onResults(Landroid/os/Bundle;)V
    .registers 4

    .line 157
    nop

    .line 158
    const-string v0, "results_recognition"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getStringArrayList(Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object p1

    .line 159
    if-eqz p1, :cond_1a

    invoke-virtual {p1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1a

    .line 160
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;->mResult:[Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    aput-object p1, v0, v1

    .line 162
    :cond_1a
    iget-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$Listener;->mDone:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 163
    return-void
.end method

.method public onRmsChanged(F)V
    .registers 2

    .line 173
    return-void
.end method
