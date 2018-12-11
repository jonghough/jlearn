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
![kpca](/dr/kpca_iris.png)

## Factor Analysis

Factor analysis is another algorithm for reducing the dimensionality of a dataset by selecting variables...

### Example using the *iris dataset*

```
data =: 4 readCSV_jLearnUtil_ '~Projects/jlearn/datasets/iris.csv'
'X Y Z W'=: splitDataset_jLearnUtil_ data,(1.0;1)
NB. create factor analysis solver
fa =: 2 conew 'FASolver'

fit__fa X

D =: X dot W__fa
y1 =: I. 1 0 0 -:"_ 1 Y
y2 =: I. 0 1 0 -:"_ 1 Y
y3 =: I. 0 0 1 -:"_ 1 Y

d1 =: y1{D
d2 =: y2{D
d3 =: y3{D

pd 'reset'
pd 'type marker'
pd (<"1|: d1) 
pd (<"1|: d2)
pd (<"1|: d3)
pd 'show'
```
We can see the 3 classes are clearly defined, using our 2-d reduced dataset.
![fa](/dr/fa_iris_01.png)