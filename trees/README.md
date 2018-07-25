# Example usage

## Drawing a contour graph with iris dataset

```j
NB. initialize and train the decision tree
tree=: (20;200;'gini';'a';0) conew 'jLearnTree'
Y fit__tree X
```

Predict the classes for a 2D array of values. The values will be of the 
form [0.5,0.5,x,y], where x will be values along the x axis of the 
plot, and y will be values along the y axis. The first two features
of each test datapoint will be kept at a constant value of 0.5

```j
S=: steps 0 1 60 NB. 60 steps in range [0..1]
predictedVals =: #.@:predict__root@:(0.5 0.5&,@:,)
Z=: pred"(0 0)/~ S NB. Z is a 60x60 array of values representing predicted classes
plotContour_jlplot_ S;S;Z;'contour plot, for iris datapoints (0.5, 0.5, x, y)'

```

 
![dtplot](/trees/decisiontree_contour.png)

## Regression Tree
Regression trees work similarly to Classification trees.

### Example
Example using the yacht hydrodynamics dataset from http://archive.ics.uci.edu/ml/datasets/yacht+hydrodynamics .

As explained on the website:
<i>Variations concern hull geometry coefficients and the Froude number: 

1. Longitudinal position of the center of buoyancy, adimensional. 
2. Prismatic coefficient, adimensional. 
3. Length-displacement ratio, adimensional. 
4. Beam-draught ratio, adimensional. 
5. Length-beam ratio, adimensional. 
6. Froude number, adimensional. 

The measured variable is the residuary resistance per unit weight of displacement: 
7. Residuary resistance per unit weight of displacement, adimensional.</i>

```j
data=: readCSVR_jLearnUtil_ '/path/to/yacht/dataset/csv'
'X Y Z W'=: splitDataset_jLearnUtil_ data,(0.4;1)
NB. build the regression tree. Maximum depth 10, maximum leaf number 500, splitting is random ('r')
tree=: (10;500; 'r') conew 'DTR'
Y fit__tree X
```

Test the accuracy using *Explained Variance* score.
```j
explainedVariance_jLearnScorer_ W;predict__tree Z
 0.773
```
