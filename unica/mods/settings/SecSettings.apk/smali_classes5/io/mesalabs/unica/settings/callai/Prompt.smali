.class final Lio/mesalabs/unica/settings/callai/Prompt;
.super Ljava/lang/Object;
.source "Prompt.java"


# static fields
.field static final DEFAULT_PERSONA:Ljava/lang/String; = "A polite personal assistant answering the phone on behalf of its owner."


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static build(Landroid/content/Context;)Ljava/lang/String;
    .registers 5

    .line 37
    const-string v0, "unica_ca_persona"

    const-string v1, "A polite personal assistant answering the phone on behalf of its owner."

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 38
    const-string v1, "unica_ca_instructions"

    const-string v2, ""

    invoke-static {p0, v1, v2}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 40
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 41
    const-string v0, "\n\nYou are speaking on a live phone call on behalf of the phone\'s owner."

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 42
    const-string v3, "\nReply in "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/Prompt;->language(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lio/mesalabs/unica/settings/callai/Prompt;->languageName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, " only."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 43
    const-string v0, "\nKeep every reply to one or two short spoken sentences."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 44
    const-string v0, "\nSpeak naturally, the way a person answers a phone, and never read out"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 45
    const-string v0, " lists, markdown, emoji or anything that cannot be spoken aloud."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 46
    const-string v0, "\nNever mention that you are an AI unless the caller asks directly."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 47
    const-string v0, "\nNever invent facts about the owner. If the caller wants something only"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 48
    const-string v0, " the owner can decide, say you will pass the message on."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 49
    const-string v0, "\nIf the caller asks for something urgent, take the details and confirm"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 50
    const-string v0, " them back briefly."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 51
    const-string v0, "\nDo not stay silent: if you did not understand, ask the caller to repeat."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "\nIf the caller wants to end the call, says goodbye, or the conversation is finished, say a polite brief goodbye and append [HANGUP] at the end of your reply."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "\nIf the caller is trolling, laughing, joking around, or wasting time without a serious purpose, do not entertain them. Politely say goodbye and append [HANGUP] at the end of your reply."

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 53
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_77

    .line 54
    const-string p0, "\n\nAdditional instructions from the owner, these take priority:\n"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 55
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 57
    :cond_77
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static language(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    .line 33
    const-string v0, "unica_ca_language"

    const-string v1, "ar"

    invoke-static {p0, v0, v1}, Lio/mesalabs/unica/settings/callai/CallAiConfig;->get(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static languageName(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 22
    const-string v0, "en"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 23
    const-string p0, "English"

    return-object p0

    .line 25
    :cond_b
    const-string v0, "ar_eg"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_16

    .line 26
    const-string p0, "Egyptian Arabic dialect"

    return-object p0

    .line 28
    :cond_16
    const-string p0, "Arabic"

    return-object p0
.end method
