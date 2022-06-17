# Action Recognition Documentation

## Content

[TOC]



## 1. Function Introduction

SDK has the function module of human action recognition, which can obtain the pre-defined action type discrimination.

## 2. Interface Introduction

Get the predefined action type through fuHumanProcessorGetResultActionType.

### Get interface

```
/**
 \brief get ai model HumanProcessor's action type with index.
 \param index, index of fuHumanProcessorGetNumResults
 */
FUNAMA_API int fuHumanProcessorGetResultActionType(int index);

Parameters：

index：The number of the inquired human body is 0 in the case of single person

Return Value:

1-14 represent different action types, and 0 represents unknown result
```

### Action Definition  
Actions 1 to 14, to avoid ambiguity, use the graphic pose definition.

Action 1
![1](./imgs/pose/1.jpg)

Action 2
![2](./imgs/pose/2.jpg)

Action 3
![3](./imgs/pose/3.jpg)

Action 4
![4](./imgs/pose/4.jpg)

Action 5
![5](./imgs/pose/5.jpg)

Action 6
![6](./imgs/pose/6.jpg)

Action 7
![7](./imgs/pose/7.jpg)

Action 8
![8](./imgs/pose/8.jpg)

Action 9
![9](./imgs/pose/9.jpg)

Action 10
![10](./imgs/pose/10.jpg)

Action 11
![11](./imgs/pose/11.jpg)

Action 12
![12](./imgs/pose/12.jpg)

Action 13
![13](./imgs/pose/13.jpg)

Action 14
![14](./imgs/pose/14.jpg)




