Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 1
Implementation of K-Means / K-Medians classifier. If the distance metric is chosen to
be Manhatten (i.e. L1 norm) then the class essentially runs the K-Medians algorithm on the data.


Example usage, where 'trainX' is the input dataset, 'trainy' is the corresponding
target values. 'Euclidean' represents use of Euclidean distance measure. The
final param, '3', represents the number of classes to split the dataset into.

KMClassifier =: ((({~ ?~@#) trainX);'euclidean';3) conew 'KMeans'

fit__KMClassifier 100
)

Note 'References'
[1] Understanding the K-Medians Problem, Christopher Whelan, Greg Harrell, and Jin Wang 
link: http://worldcomp-proceedings.com/proc/p2015/CSC2663.pdf
)


coclass 'KMeans'

dot=: +/ .*         NB. dot product
dsq=: +/@:(*:@-)    NB. euclidean distance squared
manhattan=: +/@:|@:-   NB. manhattan distance
min=: I.@:(=<./)    NB. array minimum value

NB. Names of the metrics used.
M=: 'manhattan'
E=: 'euclidean'
NB. Distance metric can be any of
NB.	1. 'Euclidean'
NB.	2. 'Manhattan'
metric=: 'euclidean'
isMetricDefinition=: 3 : '(M;E) e.~ < y'


NB. Creates an instance of the KMeans class. Used for
NB. Clustering data, with a given number of labels.
NB. y:
NB. 0: dataset
NB. 1: distance metric to use. Can be
NB.    'Euclidean' for Euclidean metric
NB.    'Manhatten' for Manahatten metric
NB. 2: number of means, components to use
NB. 3: initial centroid distribution. Can be
NB.    'normal'
NB.    'uniform'

create=: 3 : 0
'data metric k distribution'=: y      
dimensions=: ~.#"1 data    NB. dimensionality of the dataset
NB. generate the means, uniformly random between 0 and 1.
means=: ? (k, dimensions)$ 0 
'Metric must be euclidean or manhattan' assert (isMetricDefinition metric)
if. metric -: 'euclidean' do. distFunc=: dsq
else. distFunc=: manhattan end.
means=: initCentroids 0
fitFinished=: 0
)


NB. Initializes the centroids of the kmeans algorithm. The
NB. centroids are initialized from random samples from
NB. a normal disgtribution with mean,var equal to the
NB. mean and var of the feature sets.
NB. y: NO PARAMS
initCentroids=: 3 : 0 
m=. (+/ % #) data
if. distribution-:'normal' do.	NB. means of dataset features
  var=. (+/@(*:@(] - +/ % #)) % #) "1
  std=. %: var |: data
  
 |: k bmt_jLearnUtil_"_ 1  |: ((+/ % #) data),: std
elseif. distribution-:'uniform' do.
  m +"1 1"1 _ ? (k, dimensions)$ 0
elseif. 1 do.
throw. 'Initial distribution is not known, ',": distribution
end.
)

NB. Run the k-means algorthm.
NB. y: number of iterations to run the kmeans algorithm.
NB. returns: he mean values
fit=: 3 : 0
assert. -. y -: ''
epochsmax	=. y
epochs	=. 0
labels	=: ''
compLabels=: #: 2 ^ i. k

while. epochsmax > epochs=. >: epochs do.
  labels=: data (= <./)"1@:((distFunc)"1 1"1 _) means
  indexes=: <"1@I. >"2 (<"1 compLabels) ((-:)&.>)"0 _ <"1 labels
  means=: > indexes ((+/ % #)@:{)&.> <data
end.
fitFinished=: 1
means
)

NB. Predict the classes of the given input feature(s).
NB. Parameters:
NB. 0: The datapoints for which to find the predicted labels.
NB. Returns:
NB.   Predicted labels for each datapoint in the input.
predict=: 3 : 0
y (= <./)"1@:((distFunc)"1 1"1 _) means
)

destroy=: codestroy
