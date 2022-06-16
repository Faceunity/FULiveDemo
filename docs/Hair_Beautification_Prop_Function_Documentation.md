# Hair Beautification Prop Interface Documentation

## Content

[TOC]

## 1. Function Introduction
Hair beautification is based on high-precision hair segmentation model, and adds image rendering technologies such as solid color and gradient color to realize one click hair color effect, and open interface to support user-defined makeup color value.

## 2. Interface Introduction
The parameter interface of hairdressing function is based on props, and the input parameters are all through ** fuItemSetParam **.
### Monochrome hair props (hair_normal.bundle)

#### Parameters：

- Index        This prop preset 8 kinds of hair color, this parameter set value 0-7 corresponding.
- Strength     This parameter is used to control the color intensity, 0 corresponds to no effect, 1 corresponds to the strongest effect, and the middle is continuous transition.
- Col_L        Change hair color，Col_L = L/100.0，L is the L value of LAB color space.
- Col_A        Change hair color，Col_A = A/254.0 + 0.5，A is the A value of the LAB color space.
- Col_B        Change hair color, Col_B = B/254.0 + 0.5, B is the B value of LAB color space.
- Shine        Change the hair gloss, the value range: 0.0 ~ 3.0, 0.0 for matte, 3.0 for maximum gloss.

#### Attention 
According to the order of parameter setting, if Index is set first, then {Col_L, Col_A, Col_B, Shine is set}, the color of {Col_L, Col_A, Col_B, Shine} will be displayed. If {Col_L, Col_A, Col_B, Shine} is set first, then set Index, the default Index color will be displayed.

If the SDK is above 6.6, you need to load the preset hair beautification ability props（ai_hairseg.bundle）, which is loaded through the function **fuLoadAIModelFromPackage**.

### Gradient hair props (hair_gradient.bundle)

#### Parameter：

- Index      This prop preset 5 kinds of gradient color, this parameter set value 0-4 corresponding.
- Strength   This parameter is used to control the color intensity, 0 corresponds to no effect, 1 corresponds to the strongest effect, and the middle is continuous transition.
- Col0_L      Change hair color 0，Col0_L = L0/100.0，L0 is the L value of LAB color space.
- Col0_A      Change hair color 0，Col0_A = A0/254.0 + 0.5，A0 is the A value of LAB color space.
- Col0_B      Change hair color 0，Col0_B = B0/254.0 + 0.5, B0 is the B value of the LAB color space.
- Col1_L      Change hair color 1，Col1_L = L1/100.0，L1 is the L value of LAB color space.
- Col1_A      Change hair color 1，Col1_A = A1/254.0 + 0.5，A1 is the A value of LAB color space.
- Col1_B      Change hair color 1，Col1_B = B1/254.0 + 0.5, B1 is the B value of LAB color space.
- Shine0      Change the hair glossiness 0, the value range: 0.0 ~ 4.0, 0.0 for matte, 4.0 for maximum glossiness.
- Shine1      Change the hair glossiness 1, the value range: 0.0 ~ 4.0, 0.0 for matte, 4.0 for maximum glossiness.

#### Notes 
According to the order of parameter setting, if Index is set first, then {Col01_L, Col01_A, Col01_B, Shine01} is set, the color of {Col01_L, Col01_A, Col01_B, Shine01} will be displayed. If {Col01_L, Col01_A, Col01_B, Shine01} is set first, then set Index, the default Index color will be displayed.

If the SDK is above 6.6, you need to load the preset hair beautification ability props （ai_hairseg.bundle）, which is loaded through the function **fuLoadAIModelFromPackage**.