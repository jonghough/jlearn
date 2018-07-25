# Dimensionality Reduction

## Principle Component Analysis


## Kernel Principle Component Analysis

```
k=: (X;'d';1;1;2) conew 'KPCASolver'
pd 'reset'
pd 'type dot'
pd ;/ |: reduced__k
pd 'show'


R1 =: 3 50 $, {."1 reduced__k
R2=: 3 50 $, {:"1 reduced__k
pd 'reset'
pd 'type marker'
pd R1;R2
pd 'show'
```
![kpca] (/dr/kpca_iris.png)

## Factor Analysis
