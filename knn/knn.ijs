Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Implementation of K-Nearest Neighbour algorithm.

coclass 'KNN'

NB. Runs the k-nn algorithm to find the k-nearest neighbours
NB. of the given input datapoints for the given
NB. dataset. 
NB. params:
NB. 0: dataset of data points
NB. 1: number of neighbours
NB. 2: number of classes
NB. 3: input datapoints to search nearest neighbours for.
NB. 
NB. Example.
NB. >  knn=: ((>0{D);(>1{D);7;I) conew 'KNN'
NB. >  NB. I is some arbitrary points
NB. >  NB. D is the dataset;classes
NB. >  NB. 7 indicates we want to find the 7 nn classes
NB. >  ...
NB. >  NB. generate  nearest neighbours
NB. >  predict__knn ''
NB.
create=: 3 : 0
'd c k i'=:y
)

NB. Returns the predicted classes per each
NB. input datapoint.
returnMaxClass=: 3 : 0
a=. (#/.~ y)
b=. (~. <"1 y) /: a
{:b
)

NB. 
enumerateClasses=: 3 : 0
<(~. <"1 y) ,: <"0 (#/.~ y)
)

NB. Predicts the classes for each of the input 
NB. datapoints. For each datapoint this will return
NB. the k-classes representing the k-nearest neighbours. 
predict=: 3 : 0 " 1
dc=: d;c
findnn=: k&{.@:(([ +/@:*:@:-"_ 1 >@:{.@:]) /:~ >@:{:@:]) 
nnset =: i findnn"1 _ dc
distances=: nnset
maxClasses=: returnMaxClass"2 nnset
enumerateClasses"2 nnset
)

destroy=: codestroy

Note 'Example'

> knn=: (data,2;(>{.data)) conew 'KNN'
> predict__knn ''
> R=: I.&:> (~. ="0 _ ])#.&:> maxClasses__knn
> pd 'reset'
> pd 'type marker'
> pd <"2 (<"1 |:2{."1 >{.data) ({~&:>)"0 _ <"1 R
> pd 'show'
)