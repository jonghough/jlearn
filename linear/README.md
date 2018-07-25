# Linear Regression and Logistic Regression


## Linear Regression

### Example

Define a simple function of two variables:
*f(x,y)= sin(x) + y^2 + e*,
where *e* is some small random number.
```j
f=: 3 : ' (20%~?1$0) + (1&o.@:{. y) + (*:{:y)'
A=: ? 100 2 $ 0
B=: ? 30 2 $ 0 
Ta=: f"1 A       NB. target values for training
Tb=: f"1 B       NB. target values for testing
NB. Linear Regressor.
Reg=:(2;20;0.1;5;'l2') conew 'LinearRegressor'
T fit__Reg A

plot |: Tb,.predict__R B
explainedVariance_jLearnScorer_ Tb;predict__Reg B
```

### Example using Cereals data
Data is from: http://lib.stat.cmu.edu/DASL/Datafiles/Cereals.html

This is the "Healthy Breakfast" dataset. We would like to use the
variables to predict the Rating of each cereal.
```j
data=: readcsv '/path/to/cereals.csv'
NB. We need to do some data preprocessing first, to cleanup the inputs
NB. need to cleanup and get rid of headers etc.
data=: }."1}. data
data=: 0 1 numberColumnReplace_jLearnUtil_ data
data=: > (".@:":)&.> data NB. make all numeric
NB. split into inout and output
data=: (}:"1;(|:@:,:@:{:"1)) data
NB. (X,Y) is training, (Z,W) is test.
'X Y Z W'=: splitDataset_jLearnUtil_ data,(0.8;1)

Reg=:(14;5;0.001;5;'l2') conew 'LinearRegressor'
Y fit__Reg X

NB. get the exlained variance
 explainedVariance_jLearnScorer_ W;predict__Reg Z

NB. plot, if necessary
require 'plot'
plot |: W,. predict__Reg Z
```

### Logistic Regression

## Example
Example using Linear classifier with linear separable
training data.
Create some data that is easy to verify as being linear separable:

data =: 5 3 $ 0.6 _0.2 _0.99,    0.44 _0.2 _0.4,  _0.5 0.99 _0.1,  _0.233 _0.75 0.69, _0.1 _0.4 0.2
targ =: 5 3 $ 1 0 0 1 0 0 0 1 0 0 0 1 0 0 1

i.e. the positive feature is the class.

LC =: (3;3;4;'gd';'softmax';0.02;3; 'l2') conew 'LRC'
targ fit__LC data

## Example
...