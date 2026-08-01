.class public final Lio/mesalabs/unica/settings/callai/CallAiReceiver;
.super Landroid/content/BroadcastReceiver;
.source "CallAiReceiver.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "UnicaCallAi"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 15
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method

.method private static isUnknown(Landroid/content/Context;Ljava/lang/String;)Z
    .registers 4

    .line 61
    const/4 v0, 0x1

    if-eqz p1, :cond_14

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_e

    goto :goto_14

    .line 64
    :cond_e
    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/callai/Contacts;->isKnown(Landroid/content/Context;Ljava/lang/String;)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0

    .line 62
    :cond_14
    :goto_14
    return v0
.end method

.method private static shouldAnswer(Landroid/content/Context;Ljava/lang/String;)Z
    .registers 4

    .line 47
    const-string v0, "unica_ca_trigger"

    const-string v1, "manual"

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 49
    const-string v1, "all"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_12

    .line 50
    const/4 p0, 0x1

    return p0

    .line 52
    :cond_12
    const-string v1, "unknown"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1f

    .line 53
    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/callai/CallAiReceiver;->isUnknown(Landroid/content/Context;Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 56
    :cond_1f
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 5

    .line 20
    const-string v0, "android.intent.action.PHONE_STATE"

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_d

    .line 21
    return-void

    .line 23
    :cond_d
    const-string v0, "state"

    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 25
    sget-object v1, Landroid/telephony/TelephonyManager;->EXTRA_STATE_IDLE:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1f

    .line 28
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiService;->stop(Landroid/content/Context;)V

    .line 29
    return-void

    .line 31
    :cond_1f
    sget-object v1, Landroid/telephony/TelephonyManager;->EXTRA_STATE_RINGING:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_28

    .line 32
    return-void

    .line 34
    :cond_28
    invoke-static {p1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_2f

    .line 35
    return-void

    .line 38
    :cond_2f
    const-string v0, "incoming_number"

    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 39
    invoke-static {p1, p2}, Lio/mesalabs/unica/settings/callai/CallAiReceiver;->shouldAnswer(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3c

    .line 40
    return-void

    .line 42
    :cond_3c
    const-string v0, "UnicaCallAi"

    const-string v1, "incoming call matches the trigger, arming the assistant"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 43
    const-string v0, "io.mesalabs.unica.callai.START"

    invoke-static {p1, v0, p2}, Lio/mesalabs/unica/settings/callai/CallAiService;->start(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 44
    return-void
.end method
