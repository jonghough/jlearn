Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 1
Tree classifier / regressor utility verbs.
The locale jLearnTreeUtil contains the criterion and split
verbs for the decision tree classifiers and regressors to
use when splitting nodes. The defined criterions are
1. gini criterion
2. entropy
3. mse criterion
)

cocurrent 'jLearnTreeUtil'

 
NB. Gini criterion
giniCriterion=: 1&-@:(+/@:*:)


NB. entropy quantity, given by the negative sum of each probability, p,
NB. multiplied by the base-2 log of p.
entropy=: -@:(+/)@:(* 2&^.)

NB. a random split point. A random splitting-point is chosen between
NB. the range (min, max) where min and max are the minimum and maximum
NB. values of the given feature dataset.
splitRand=: 3 : '? 0' NB. (3 : 'y*? 0'@:(>./@:[ - ]) + ]) <./

NB. Chooses the splitting-point as the mean of the given feature dataset.
splitAvg=: (+/ % #)


NB. Regression Criterion is measured by the CART cost function
NB. for regression. The MSE error (left + right) for each feature
NB. is minimized.
regCriterion=: 3 : 0
'data ts'=.y
smoutput 'data 0 ',": {.data
smoutput 'ts 0 ',": {. ts
smoutput $ ts
splits=: ''
d=: ''

for_i.  i. 1{$data do.
  set=: i{"1 data
  if. 1 = # ~. set do.
    splits=: splits,_
    d=: d, <_
  else.
    p=: splitAvg set
    splits=: splits,p
    ltIndex=: p> set
    gteIndex=. -. ltIndex
    tbarLeft=: (#ltIndex) %~ +/ (I. ltIndex) { ts
    tbarRight=: (#gteIndex) %~ +/ (I. gteIndex) { ts
    left=: ((#ltIndex) % # ts) * (+/, *: (,(I. ltIndex) { ts) -"_ 0 tbarLeft)
    right=: ((#gteIndex) % # ts) * (+/, *: (,(I. gteIndex) { ts) -"_ 0 tbarRight)
    d=: d, <left+right
  end.
end.
minMSE=. {.I. (=<./) > d
minMSE;(minMSE{splits)
)

