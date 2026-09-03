.class public Lio/mesalabs/unica/audio/Biquad;
.super Ljava/lang/Object;
.source "Biquad.java"


# instance fields
.field public a1:F

.field public a2:F

.field public b0:F

.field public b1:F

.field public b2:F

.field public z1:F

.field public z2:F


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 3
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run(F)F
    .locals 3

    .line 71
    iget v0, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    mul-float v0, v0, p1

    iget v1, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    add-float/2addr v0, v1

    .line 72
    iget v1, p0, Lio/mesalabs/unica/audio/Biquad;->b1:F

    mul-float v1, v1, p1

    iget v2, p0, Lio/mesalabs/unica/audio/Biquad;->a1:F

    mul-float v2, v2, v0

    sub-float/2addr v1, v2

    iget v2, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    add-float/2addr v1, v2

    iput v1, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    .line 73
    iget v1, p0, Lio/mesalabs/unica/audio/Biquad;->b2:F

    mul-float v1, v1, p1

    iget p1, p0, Lio/mesalabs/unica/audio/Biquad;->a2:F

    mul-float p1, p1, v0

    sub-float/2addr v1, p1

    iput v1, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    .line 74
    return v0
.end method

.method public setHighpass(FFF)V
    .locals 4

    .line 12
    const/high16 v0, 0x41a00000    # 20.0f

    cmpg-float v0, p2, v0

    if-lez v0, :cond_1

    const v0, 0x3ef5c28f    # 0.48f

    mul-float v0, v0, p1

    cmpl-float v0, p2, v0

    if-ltz v0, :cond_0

    goto :goto_0

    .line 16
    :cond_0
    const-wide v0, 0x401921fb54442d18L    # 6.283185307179586

    float-to-double v2, p2

    invoke-static {v2, v3}, Ljava/lang/Double;->isNaN(D)Z

    mul-double v2, v2, v0

    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr v2, p1

    double-to-float p1, v2

    .line 17
    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Math;->cos(D)D

    move-result-wide v0

    double-to-float v0, v0

    .line 18
    invoke-static {p1, p2}, Ljava/lang/Math;->sin(D)D

    move-result-wide p1

    double-to-float p1, p1

    const/high16 p2, 0x40000000    # 2.0f

    mul-float p3, p3, p2

    div-float/2addr p1, p3

    .line 19
    const/high16 p2, 0x3f800000    # 1.0f

    add-float p3, p1, p2

    .line 21
    add-float v1, v0, p2

    const/high16 v2, 0x3f000000    # 0.5f

    mul-float v2, v2, v1

    div-float/2addr v2, p3

    iput v2, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    .line 22
    neg-float v1, v1

    div-float/2addr v1, p3

    iput v1, p0, Lio/mesalabs/unica/audio/Biquad;->b1:F

    .line 23
    iget v1, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    iput v1, p0, Lio/mesalabs/unica/audio/Biquad;->b2:F

    .line 24
    const/high16 v1, -0x40000000    # -2.0f

    mul-float v0, v0, v1

    div-float/2addr v0, p3

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->a1:F

    .line 25
    sub-float/2addr p2, p1

    div-float/2addr p2, p3

    iput p2, p0, Lio/mesalabs/unica/audio/Biquad;->a2:F

    .line 26
    const/4 p1, 0x0

    iput p1, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    iput p1, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    .line 27
    return-void

    .line 13
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lio/mesalabs/unica/audio/Biquad;->setPassthrough()V

    .line 14
    return-void
.end method

.method public setHighshelf(FFF)V
    .locals 8

    .line 50
    const/high16 v0, 0x41a00000    # 20.0f

    cmpg-float v0, p2, v0

    if-lez v0, :cond_1

    const v0, 0x3ef5c28f    # 0.48f

    mul-float v0, v0, p1

    cmpl-float v0, p2, v0

    if-gez v0, :cond_1

    invoke-static {p3}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const v1, 0x3dcccccd    # 0.1f

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    goto :goto_0

    .line 54
    :cond_0
    const-wide v0, 0x401921fb54442d18L    # 6.283185307179586

    float-to-double v2, p2

    invoke-static {v2, v3}, Ljava/lang/Double;->isNaN(D)Z

    mul-double v2, v2, v0

    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr v2, p1

    double-to-float p1, v2

    .line 55
    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Math;->cos(D)D

    move-result-wide v0

    double-to-float v0, v0

    .line 56
    invoke-static {p1, p2}, Ljava/lang/Math;->sin(D)D

    move-result-wide p1

    double-to-float p1, p1

    .line 57
    float-to-double p2, p3

    const-wide/high16 v1, 0x4044000000000000L    # 40.0

    invoke-static {p2, p3}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr p2, v1

    const-wide/high16 v1, 0x4024000000000000L    # 10.0

    invoke-static {v1, v2, p2, p3}, Ljava/lang/Math;->pow(DD)D

    move-result-wide p2

    double-to-float p2, p2

    .line 58
    const/high16 p3, 0x40000000    # 2.0f

    div-float/2addr p1, p3

    const/high16 v1, 0x3f800000    # 1.0f

    div-float v2, v1, p2

    add-float/2addr v2, p2

    const/4 v3, 0x0

    mul-float v2, v2, v3

    add-float/2addr v2, p3

    float-to-double v4, v2

    invoke-static {v4, v5}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v4

    double-to-float v2, v4

    mul-float p1, p1, v2

    .line 59
    float-to-double v4, p2

    invoke-static {v4, v5}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v4

    double-to-float v2, v4

    mul-float v2, v2, p3

    mul-float v2, v2, p1

    .line 61
    add-float p1, p2, v1

    sub-float v1, p2, v1

    mul-float v4, v1, v0

    sub-float v5, p1, v4

    add-float v6, v5, v2

    .line 62
    add-float/2addr v4, p1

    add-float v7, v4, v2

    mul-float v7, v7, p2

    div-float/2addr v7, v6

    iput v7, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    .line 63
    const/high16 v7, -0x40000000    # -2.0f

    mul-float v7, v7, p2

    mul-float p1, p1, v0

    add-float v0, v1, p1

    mul-float v7, v7, v0

    div-float/2addr v7, v6

    iput v7, p0, Lio/mesalabs/unica/audio/Biquad;->b1:F

    .line 64
    sub-float/2addr v4, v2

    mul-float p2, p2, v4

    div-float/2addr p2, v6

    iput p2, p0, Lio/mesalabs/unica/audio/Biquad;->b2:F

    .line 65
    sub-float/2addr v1, p1

    mul-float v1, v1, p3

    div-float/2addr v1, v6

    iput v1, p0, Lio/mesalabs/unica/audio/Biquad;->a1:F

    .line 66
    sub-float/2addr v5, v2

    div-float/2addr v5, v6

    iput v5, p0, Lio/mesalabs/unica/audio/Biquad;->a2:F

    .line 67
    iput v3, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    iput v3, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    .line 68
    return-void

    .line 51
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lio/mesalabs/unica/audio/Biquad;->setPassthrough()V

    .line 52
    return-void
.end method

.method public setPassthrough()V
    .locals 1

    .line 7
    const/high16 v0, 0x3f800000    # 1.0f

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    .line 8
    const/4 v0, 0x0

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->a2:F

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->a1:F

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->b2:F

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->b1:F

    .line 9
    return-void
.end method

.method public setPeaking(FFFF)V
    .locals 5

    .line 30
    const/high16 v0, 0x41a00000    # 20.0f

    cmpg-float v0, p2, v0

    if-lez v0, :cond_1

    const v0, 0x3ef5c28f    # 0.48f

    mul-float v0, v0, p1

    cmpl-float v0, p2, v0

    if-gez v0, :cond_1

    invoke-static {p4}, Ljava/lang/Math;->abs(F)F

    move-result v0

    const v1, 0x3dcccccd    # 0.1f

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    goto :goto_0

    .line 34
    :cond_0
    const-wide v0, 0x401921fb54442d18L    # 6.283185307179586

    float-to-double v2, p2

    invoke-static {v2, v3}, Ljava/lang/Double;->isNaN(D)Z

    mul-double v2, v2, v0

    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr v2, p1

    double-to-float p1, v2

    .line 35
    float-to-double p1, p1

    invoke-static {p1, p2}, Ljava/lang/Math;->cos(D)D

    move-result-wide v0

    double-to-float v0, v0

    .line 36
    invoke-static {p1, p2}, Ljava/lang/Math;->sin(D)D

    move-result-wide p1

    double-to-float p1, p1

    .line 37
    float-to-double v1, p4

    const-wide/high16 v3, 0x4044000000000000L    # 40.0

    invoke-static {v1, v2}, Ljava/lang/Double;->isNaN(D)Z

    div-double/2addr v1, v3

    const-wide/high16 v3, 0x4024000000000000L    # 10.0

    invoke-static {v3, v4, v1, v2}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v1

    double-to-float p2, v1

    .line 38
    const/high16 p4, 0x40000000    # 2.0f

    mul-float p3, p3, p4

    div-float/2addr p1, p3

    .line 39
    div-float p3, p1, p2

    const/high16 p4, 0x3f800000    # 1.0f

    add-float v1, p3, p4

    .line 41
    mul-float p1, p1, p2

    add-float p2, p1, p4

    div-float/2addr p2, v1

    iput p2, p0, Lio/mesalabs/unica/audio/Biquad;->b0:F

    .line 42
    const/high16 p2, -0x40000000    # -2.0f

    mul-float v0, v0, p2

    div-float/2addr v0, v1

    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->b1:F

    .line 43
    sub-float p1, p4, p1

    div-float/2addr p1, v1

    iput p1, p0, Lio/mesalabs/unica/audio/Biquad;->b2:F

    .line 44
    iput v0, p0, Lio/mesalabs/unica/audio/Biquad;->a1:F

    .line 45
    sub-float/2addr p4, p3

    div-float/2addr p4, v1

    iput p4, p0, Lio/mesalabs/unica/audio/Biquad;->a2:F

    .line 46
    const/4 p1, 0x0

    iput p1, p0, Lio/mesalabs/unica/audio/Biquad;->z2:F

    iput p1, p0, Lio/mesalabs/unica/audio/Biquad;->z1:F

    .line 47
    return-void

    .line 31
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lio/mesalabs/unica/audio/Biquad;->setPassthrough()V

    .line 32
    return-void
.end method
