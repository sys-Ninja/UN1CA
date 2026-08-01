.class public final synthetic Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/speech/tts/TextToSpeech$OnInitListener;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/callai/TtsEngine;

.field public final synthetic f$1:Ljava/util/concurrent/CountDownLatch;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;->f$0:Lio/mesalabs/unica/settings/callai/TtsEngine;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;->f$1:Ljava/util/concurrent/CountDownLatch;

    return-void
.end method


# virtual methods
.method public final onInit(I)V
    .registers 4

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;->f$0:Lio/mesalabs/unica/settings/callai/TtsEngine;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/TtsEngine$$ExternalSyntheticLambda0;->f$1:Ljava/util/concurrent/CountDownLatch;

    invoke-static {v0, v1, p1}, Lio/mesalabs/unica/settings/callai/TtsEngine;->$r8$lambda$V8cbDZ7ZWcTeoams3WLcHKs8uqE(Lio/mesalabs/unica/settings/callai/TtsEngine;Ljava/util/concurrent/CountDownLatch;I)V

    return-void
.end method
