.class public final synthetic Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/callai/SttEngine;

.field public final synthetic f$1:[Landroid/speech/SpeechRecognizer;

.field public final synthetic f$2:[Ljava/lang/String;

.field public final synthetic f$3:Ljava/util/concurrent/CountDownLatch;

.field public final synthetic f$4:Landroid/content/Intent;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/callai/SttEngine;[Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V
    .registers 6

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$0:Lio/mesalabs/unica/settings/callai/SttEngine;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$1:[Landroid/speech/SpeechRecognizer;

    iput-object p3, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$2:[Ljava/lang/String;

    iput-object p4, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$3:Ljava/util/concurrent/CountDownLatch;

    iput-object p5, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$4:Landroid/content/Intent;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 6

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$0:Lio/mesalabs/unica/settings/callai/SttEngine;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$1:[Landroid/speech/SpeechRecognizer;

    iget-object v2, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$2:[Ljava/lang/String;

    iget-object v3, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$3:Ljava/util/concurrent/CountDownLatch;

    iget-object v4, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda0;->f$4:Landroid/content/Intent;

    invoke-static {v0, v1, v2, v3, v4}, Lio/mesalabs/unica/settings/callai/SttEngine;->$r8$lambda$Ib0LHGTMEqILTbK2V-uGCw0ILxo(Lio/mesalabs/unica/settings/callai/SttEngine;[Landroid/speech/SpeechRecognizer;[Ljava/lang/String;Ljava/util/concurrent/CountDownLatch;Landroid/content/Intent;)V

    return-void
.end method
