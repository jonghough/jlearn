# Energy based algroithms

Examples of energy based algorithms include *Hopfield Networks* and *Restricted Boltzmann Maxhines*.

## Hopfield Networks
Hopfield Networks can be used for pattern recognition / pattern completion.
They need to be fed some patterns, whcih are stored in 'memory'. Similar patterns
can then be tested against the network which will retrieve the most similar pattern
that matches the input.

### Example

Create 3 simple and unique patterns, `p1,p2,p3`. Also create a single
test pattern, which is almost identitcal to p1. 
```j
p1 =: 4 4 $ 1 _1 _1 1 1 _1 _1 1 1 _1 _1 1 1 _1 _1 1
p2 =: 4 4 $ 1 1 1 1 _1 _1 _1 _1 _1 _1 _1 _1 1 1 1 1
p3 =: 4 4 $ 1 1 1 1 _1 _1 _1 _1 _1 1 1 _1 1 1 1 1
test =: 4 4 $ 1 _1 1 1 1 _1 _1 1 1 _1 _1 _1 1 _1 _1 1
```

Create the *Hopfield Network* and train the patterns.
```j
H=: (p1;p2;p3) conew 'Hopfield'
predict__H test
  1 _1 _1 1
  1 _1 _1 1
  1 _1 _1 1
  1 _1 _1 1
```



## Restricted Boltzmann Machines
RBMs

### Example

Choose 5 8x8 patterns that can be used as the base samples for an Restricted Boltzmann
Machine example. Each pattern is a binary image, and all are easily recognizably different
from each other by the human eye.

![rbm_samples](/energy/rbm_1.png)

### Contruction:

```j
A1=: 8 8 $ 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0
A2=: 8 8 $ 1 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 0 1 0 0 0 1 0 0 0 0 1 0 1 0 0 0 0 0 0 1
A3=: 8 8 $ 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1
A4=: 8 8 $ 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
A5=: 8 8 $ 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0

INPUT=:  |: (,A1),.(,A2),.(,A3),.(,A4),.(,A5)

rbm=: (64;200;0.1;3;5000) conew 'RBM'
fit__rbm INPUT
reconstruct__rbm ,: 0{INPUT

NB. test with a distorted and broken version of A1
TEST=: 8 8 $ 0 0 0 1 0 0 0 1, 0 1 0 0 0 0 1 0, 0 0 1 1 0 1 0 0, 0 0 0 1 0 0 0 0, 0 0 0 1 1 0 0 0, 0 0 1 0 1 1 0 0, 0 1 0 0 0 0 1 0, 1 1 0 0 0 0 0 1
8 8 $ , reconstruct__rbm ,: ,TEST
NB. A1 should have been reconstructed.
```


## RBM Classifiers

The RBM Classifier implementation puts a Logistic Regression Classifier on top of an RBM 
in the hopes of finding more accurate classification of a dataset.

### Example

```j
data=: 64 readCSV_jLearnUtil_ '/path/to/digits.csv'
'X Y Z W'=: splitDataset_jLearnUtil_ data,(0.6;1)
rbm=: (64;100;0.01;25;5000;10) conew 'RBMClassifier' 
Y fitClassify__rbm X 
 +/  W-:"1 1 (=>./)"1  predict__rbm Z
NB. gets around 90% accuracy
```
