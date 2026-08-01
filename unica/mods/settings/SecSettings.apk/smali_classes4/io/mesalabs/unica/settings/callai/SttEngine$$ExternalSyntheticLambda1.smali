.class public final synthetic Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:[Landroid/speech/SpeechRecognizer;


# direct methods
.method public synthetic constructor <init>([Landroid/speech/SpeechRecognizer;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda1;->f$0:[Landroid/speech/SpeechRecognizer;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 2

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/SttEngine$$ExternalSyntheticLambda1;->f$0:[Landroid/speech/SpeechRecognizer;

    invoke-static {v0}, Lio/mesalabs/unica/settings/callai/SttEngine;->lambda$local$1([Landroid/speech/SpeechRecognizer;)V

    return-void
.end method
