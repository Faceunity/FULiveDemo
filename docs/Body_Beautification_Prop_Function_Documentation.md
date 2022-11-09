# Body Beautification Prop Interface Documentation

## Content  

[TOC]

### 1. Function Introduction 

Body beauty function is based on 2D human body key point recognition of human beautification, with thin body, thin waist, beautiful shoulder, long legs, beautiful buttocks and other functions.

### 2. Interface Introduction  

The interface of beauty props is **fuItemSetParamd**。  

#### Specific Description  

| Parameter Name             | Value Range |                             Description                             |
| :------------------- | :------: | :----------------------------------------------------------: |
| BodySlimStrength     | 0.0~1.0  | Body Slimming: 0.0 means the intensity is 0. The higher the value is, the greater the intensity is, and the more obvious the slimming effect is. The default value is 0.0 |
| LegSlimStrength      | 0.0~1.0  |        Long leg: 0.0 means the strength is 0. The larger the value is, the longer the leg is. The default value is 0.0        |
| WaistSlimStrength    | 0.0~1.0  |        Waist Thining: 0.0 means the strength is 0. The larger the value is, the thinner the waist is. The default value is 0.0        |
| ShoulderSlimStrength | 0.0~1.0  | Shoulder beauty: 0.5 means the strength is 0, 0.5 to 1.0. The larger the value is, the wider the shoulder is. 0.5 to 0.0, the smaller the value is, the narrower the shoulder is. 0.5 is the default value |
| HipSlimStrength      | 0.0~1.0  | Bottom beauty: 0.0 means that the strength is 0. The greater the value is, the greater the strength is, and the more obvious the hip lifting effect is. The default value is 0.0 |
| clearSlim            |    1     |            Reset: clear all the beauty effects and return to the default value             |
| Debug                |  0 & 1   |      Whether to turn on the debug point, 0 means off, 1 means on, and off by default       |
| HeadSlim             | 0.0~1.0  |   Small head: 0.0 means the intensity is 0. The larger the value is, the more obvious the small head effect is. The default value is 0.0    |
| LegSlim              | 0.0~1.0  |  Leg thining: 0.0 means the intensity is 0. The higher the value is, the more obvious the effect of thin leg is. The default value is 0.0   |

#### Description 

The slimming function will have some other effects, and the slimming effect is linear superposition when they are turned on at the same time.

