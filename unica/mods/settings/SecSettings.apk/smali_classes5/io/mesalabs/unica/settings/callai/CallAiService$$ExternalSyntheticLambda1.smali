.class public final synthetic Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/callai/CallAiService;

.field public final synthetic f$1:Lio/mesalabs/unica/settings/callai/LiveClient;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/callai/CallAiService;Lio/mesalabs/unica/settings/callai/LiveClient;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;->f$0:Lio/mesalabs/unica/settings/callai/CallAiService;

    iput-object p2, p0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;->f$1:Lio/mesalabs/unica/settings/callai/LiveClient;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 3

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;->f$0:Lio/mesalabs/unica/settings/callai/CallAiService;

    iget-object v1, p0, Lio/mesalabs/unica/settings/callai/CallAiService$$ExternalSyntheticLambda1;->f$1:Lio/mesalabs/unica/settings/callai/LiveClient;

    invoke-static {v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiService;->$r8$lambda$WkeNeyzrl7TGqh5yErrg1MdoTsg(Lio/mesalabs/unica/settings/callai/CallAiService;Lio/mesalabs/unica/settings/callai/LiveClient;)V

    return-void
.end method
