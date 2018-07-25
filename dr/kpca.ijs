Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Kernel PCA algorithm
NB. Applies some kernel to datapoint pairs.

Note 'References'
[1] Pattern Recognition and Machine Learning, Cristopher M. Bishop
page 586-590


)

load 'math/lapack'
load 'math/lapack/geev'
load 'math/lapack/gesvd'

coclass 'KPCASolver'

kernelExpSquared=: 3 : 0
'd1 d2 c1 c2'=. y

s=. -:- c1 * (+/"1) (*: d1 -"1 1"1 _ d2)
c2 * ^ s
)


NB. Creates a KPCASolver instance.
NB. Arguments:
NB. 0: data points
NB. 1: kernel type. Can be:
NB.    'gaussian'
NB.    ''
NB. 2: restriction, either 0 or 1. 0 implies
NB.    restricting to eigenvectors whose corresponding
NB.    eigenvalues are greater than the given limit.
NB.    1 implies  rectricting to a given number of
NB.    eigenvectors.
NB. 3: limit value. Depends on argument 1. If restriction
NB.    value is 0, then limit should be a numeric value
NB.    representing the minimum eigenvalue.
NB.    If restriction value is 1, then limit should be an
NB.    integer in the range (1,N), where N is the
NB.    total number of dimensions (features) of the dataset.
NB. 4: kernel parameter 1.
NB. 5: kernel parameter 2.
create=: 3 : 0
'X kernel restriction limit c1 c2'=. y
assert. 2=#$X
assert. restriction e. 0 1
assert. (limit < >:1{$X) *. limit>0
K=: kernelExpSquared X;X;c1;c2
N=. #X
NB. TODO don't use huge square matrix, inefficient.
I=. 1 $~ ,/~ N

K3=: (*:N)%~ I (+/ .*) K (+/ .*) I
Kr=: (K+K3)
Kn=: Kr - N%~ I (+/ .*) K 
Kd=: Kn - N%~ K (+/ .*) I 
K=: Kd  
e=. gesvd_jlapack_ K
evals=. >1{e
evecs=. >0{e
if. restriction = 0 do.
  reduced=: evecs {"_ 1~ I. evals > limit
else.
  reduced=: limit{."1 evecs
end.
smoutput limit
eigenVecs=: evecs
eigenVals=: evals
)

destroy=:codestroy
