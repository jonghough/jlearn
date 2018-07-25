# Radial Basis Function Networks

## RBF Regressors

```j
NB. create values X in range -1,1
NB. create values Y = sin(10*X)
X=: 100 1 $100%~ i: 100
Y=: 1 o. 10 * X
NB. Create RBF regressor with 5 centroids.
rbfr=: (X;Y;5;10.5) conew 'RBFRegressor'
fit__rbfr ''

NB. plot and compare Y with predicted values.
plot (|:Y),(|:predict__rbfr X)
```



![rbfreg](/rbf/rbf1.png)


## RBF Classifiers

We can use RBF networks as classifiers.

### Example with iris data

```j
data=: 4 readCSV_jLearnUtil_ '/path/to/iris.csv'
'X Y Z W' =: splitDataset_jLearnUtil_ data,(0.5;1)
rbfc=: (X;Y;6;5) conew 'RBFClassifier'
fit__rbfc ''

NB. test the model. 
NB. Show the precision, recall and f-score of the model on the test data 
prf_jLearnScorer_ W ;( (=>./)"1 predict__rbfc Z) ; 1
┌────────────┬───────────────────┬─────────────────────────┐
│1 0.925926 1│0.965517 1 0.952381│0.982456 0.961538 0.97561│
└────────────┴───────────────────┴─────────────────────────┘
```