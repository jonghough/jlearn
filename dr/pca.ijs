Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

load 'math/lapack'
load 'math/lapack/geev'
load 'math/lapack/gesvd'

coclass 'PCASolver'
mean=: +/ % #
var=: (+/@(*:@(] - +/ % #)) % #)"1
stddev=: %:@var"1
dot=: +/ . *
make2d=: 1&(,~)@:$ $ ]

create=: 3 : 0
dataMean=: 0
limit=: 20.4
eigenVecs=: ''
eigenVals=: ''
)



NB. Transforms the data by finding the
NB. subset of eigenvectors with satisfying the
NB. given restriction and limit values.
NB. Arguments:
NB. 0: data set to transform
NB. 1: restriction, either 0 or 1. 0 implies
NB.    restricting to eigenvectors whose corresponding
NB.    eigenvalues are greater than the given limit.
NB.    1 implies  rectricting to a given number of
NB.    eigenvectors.
NB. 2: limit value. Depends on argument 1. If restriction
NB.    value is 0, then limit should be a numeric value
NB.    representing the minimum eigenvalue.
NB.    If restriction value is 1, then limit should be an
NB.    integer in the range (1,N), where N is the
NB.    total number of dimensions (features) of the dataset.
NB.
NB. Example:
NB. >  pca =: '' conew 'PCASolver'
NB. >  transform__pca X;0;2.5
NB.
NB.    This will return the transformed data containing
NB.    only those eigenvectors whose corresponding eigenvalue
NB.    is greater than 2.5
NB.
NB. Example:
NB. >  pca2=: '' conew 'PCASolver'
NB. >  transform__pca X;1;3
NB.
NB.    This will return the transformed data containing the
NB.    eigenvectors for the 3 the largerst eigenvalues.
transform=: 3 : 0
'data restriction limit'=. y
assert. 2=#$data
assert. restriction e. 0 1
assert. (limit < >:1{$data) *. limit>0
means=. mean data
dataMean=: means
centered=: data -"1 1 means
S=: (#y)%~(|:centered) dot centered NB. covariance
e=. gesvd_jlapack_ S
evals=. >1{e
evecs=. >0{e
if. restriction = 0 do.
  reduced=: evecs {"_ 1~ I. evals > limit 
else.
  reduced=: limit{."1 evecs
end.

eigenVecs=: evecs
eigenVals=: evals
centered dot reduced
)

transformWithKernel=: 1 : 0
'data restriction limit'=. y
assert. 2=#$data
assert. restriction e. 0 1
assert. (limit < >:1{$data) *. limit>0
means=. mean data
dataMean=: means
centered=: make2d u"1  data -"1 1 means 
S=: (#y)%~(centered) dot |:centered NB. covariance

e=. gesvd_jlapack_ S
smoutput e
evals=. >1{e
evecs=. >0{e
if. restriction = 0 do.
  reduced=: evecs {"_ 1~ I. evals > limit 
else.
  reduced=: limit{."1 evecs
end.

eigenVecs=: evecs
eigenVals=: evals
smoutput $centered
smoutput $ reduced
(centered dot reduced); reduced; dataMean
)


NB. Inverse the PCA transform process. The reduced eigenvectors which
NB. the dataset is projected onto is transposed and multiplied by the 
NB. given datapoints, which should be the same shape as the original
NB. data. 
NB. If the forward transform can be considered as
NB.    Xr = (X - mu) dot V
NB. where X is the original dataset, mu the column means, and V the 
NB. selected eignevectors for the PCA projection transform, then
NB. the inverse can be considered
NB.    Y = mu + Xr dot Vt
NB. where Vt is transpose of V. The resulting matrix Y, will be an 
NB. approximation to X, and should be exactly equal if all eigenvectors
NB. were used in the original transform (i.e. identity transform).
NB. Arguments:
NB. 0: Dataset to invert. Should be shape (N,C) where (N,C) is the shape
NB.    of the original transformed data.
NB. returns:
NB.   Inverted transform of the given dataset.
NB.
NB. Example:
NB. >  pca = '' conew 'PCASolver'
NB. >  Xr = transform__pca X;1;2  NB. use the largest two eigenvectors
NB. >  ...
NB. > Y = inverse__pca Xr
inverse=: 3 : 0
dataMean +"1 1 y dot |: reduced
)

destroy=: codestroy
