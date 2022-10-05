# Multilayer Perceptrons

## Regressors

The `MLPRegressor` class can be used to solve regression problems.

### Example


## Classifier

THe `MLPClassifier` class can be used to solve classification problems.


### Example 1
Example classifying malignant and benign cancers using cancer dataset.

```j
'X Y Z W'=: ... NB. train and test datasets and labels.
NB. Create classifier with 4 layers, input layer (size 10), hidden layers (12,8), and output layer
(2). 
NB. Hidden layer activations are 'tanh'. 
NB. Output activation is 'softmax'.
NB. learning rate is 0.1
NB. run for 40 epochs.
NB. L2 regularization.
NB. 'sgdm' gradient optimizer
NB. batch size of 10.
myClassifier=: ((10 12 8 2);'tanh';'softmax';0.1;0.2;40;'L2';'sgdm';10) conew 'MLPClassifier'

Y fit__myClassifier X

```

#### predictions

```j
+/ W-:"1 1 (=>./)"1 predict__myClassifier Z
```

#### Precision and Recall
```j
NB. TODO
```

### Example 2

Example using the pendigits dataset

```j
myClassifier=: ((16 20 12 10);'tanh';'softmax';0.1;0.2;50;'L2';'sgdm';100) conew 'MLPClassifier'
Y fit__myClassifier X
```

```j
+/ Y-:"1 1 (=>./)"1 predict__myClassifier"1 X
```