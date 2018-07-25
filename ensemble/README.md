# Ensemble Learning

## AdaBoost 

### Example
Example classification algorithm using AdaBooster with decision trees.
Use the digit dataset. where ` 'X Y Z W'` give the training set, training labels,
test set, test labels respectively. X and Z both have 5496 datapoints in this
example, i.e. dataset split evenly between training and test.
```j
A=: (X;Y;0.1;'tree') conew 'AdaBooster'
NB. each decison tree has a maximum depth of 10, using gini criterion
setClassifier__A 12;120;'gini';'r';1
fit__A 40 NB. 40 d trees
+/ W-:"1 1 (=>./)"1 predict__A Z
   4245

```
This gives an accuracy of 77%.

Try the same but with MLPs instead of Decsion trees:

```j
A=: (X;Y;0.1;'mlp') conew 'AdaBooster'
setClassifier__A  ((16 20 20 12 10);'tanh';'softmax'; 0.01; 0.2; 3;'L2'; 'SGD';10)
fit__A 8
+/ W-:"1 1 (=>./)"1 predict__A Z
   4964
```
This gives 90% accuracy.


## Random Forest Classifier

The Random Forest Classifier class will create a set of tree classifiers, and will
perform the classificaiton fitting algorithm on each tree, using a random subset of 
the training data. The subsets are not necessarily disjoint.

As with a standalone decision tree, the user can choose the maximum depth, maximum leaf count,
criterion (gini etc), and the splitting verb (random, average) for the trees in the random forest.

### Example
This example uses the breast cancer data set (see: http://archive.ics.uci.edu/ml/datasets/breast+cancer+wisconsin+%28diagnostic%29 ).
Assume we have randomly parititoned the dataset into training (X,Y) and testing (Z,W) sets.
(Note: that the labels of the dataset need to be vectorized from 'M' and 'B' to binary vectors
`1 0` and `0 1`. Use the `vectorColumnReplace_jLearnUtil_` utility verb to do this to the boxed 
matrix of the entire dataset.

```j
NB. 50 datapoints per tree. max depth per-tree: 20, ma leaf count per-tree: 500
R=: (X;Y;50;20;500;'gini';'r') conew 'RFC'
fit__R 10  NB. 10 trees.
+/ W-:"1 1 (=>./)"1 predict__R Z
   160
# W
   171 

NB. get precision, recall, f-score
prf_jLearnScorer_ W;(predict__R Z);1
   ┌──────────┬──────────┬─────────────────┐
   │1 0.908333│0.822581 1│0.902655 0.951965│
   └──────────┴──────────┴─────────────────┘    
```



