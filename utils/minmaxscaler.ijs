Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

coclass 'MinMaxScaler'

mean=: +/ % #
variance=: +/@(*:@(] -"1 1 mean)) % #
stddev=: %:@:variance

create=: 3 : 0
'data lower upper'=: y 
assert. upper > lower
1
)

normalizeColumns2=: 3 : 0
maxCols=: >./y
minCols=: <./y
nm =: 3 : '(y -"1 1 minCols)%"1 1 (maxCols - minCols)'
nm y
)




NB. Normalizes the dataset between the range of the dataset. Each feature
NB. is normalized independently.
normalizeColumns=: 3 : 0
((] -"1 1 (<./"2)) %"1 1 (>./"2) -" 1 1 (<./"2)) data
)

NB. Normalize the dataset with the given min / max data. The
NB. data will be normalized assuming the given min max values.
NB. y: Max values. Length must match number of features
NB.    of the dataset.
NB. x: Min values. Length must match length of y.
normalizeWithRange=: 4 : 0
assert. (# y) = 1{$ data
assert. (# x) = (# y)
r=. y - x
((] -"1 1&x) %"1 1&r) data
)

NB. transformed data will have variance 1
NB. and mean 0
standardizeColumns=: 3 : 0
colMeans=: mean data
colStd=: stddev data
res=: data -"1 1 colMeans
res %"1 1 colStd
)

NB. standardize a single datapoint according to the
NB. current dataset's mean andstd deviation.
NB. y: dataset to standardize
standardizeData=: 3 : 0"1
r=. y -"1 1 colMeans
r %"1 1 colStd
)
NB. Destandardizes the input. Assumes the input is
NB. standardized data with each feature having
NB. mean, variance = 0,1
NB. y: standardized dataset
destandardize=: 3 : 0
colMeans + y * colStd
)

normalizeBetweenRange=: 3 : 0
((] -&lower) %&(upper - lower)) data
)

fit=: 3 : 0
range=: (>./ - <./) data
)


destroy=: codestroy