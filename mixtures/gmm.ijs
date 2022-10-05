Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 'References'
[1] Pattern Recognition and Machine Learning, Cristopher M. Bishop

[2] Scikit-Learn Gaussian Mixture Model implementation
link: https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/mixture/gaussian_mixture.py

[3] Referenced from Scikit-Learn's deprecated gmm implementation (gmm.py)
A paper on calculating the covariances and means for various covariance types:
link: https://www.cs.ubc.ca/~murphyk/Papers/learncg.pdf
)

Note 'Attributions'
This file is mostly a rewrite of the Scikit-Learn Gaussian Mixture Model
implementation found in reference [2].
)



require jpath '~Projects/jlearn/utils/lapackutils.ijs' 
require jpath '~Projects/jlearn/clustering/kmeans.ijs'




Note 'Example'
Example usage
>  myGMM=: (X; 3; 'tied'; 1e_5; 1; 1e_6) conew 'GMM'
>  fit__myGMM 100
)


coclass 'GMM'


cholesky=: cholesky_jUtilsLapack_
PI=: o. 1
LOG2PI=: ^.+:PI
det=: -/ . *            NB. determinant
dot=: +/ . *            NB. matrix dot product
dotty=: (|:dot])&%.
f=: |:@:[ dot dot~      NB. matrix product: M^t * N * M
columnmean=: +/ % #
NB. covGM generates a covariance matrix for the
NB. given data set.
covGM=: 100 * ((|:@:[dot])/~@:(-"1 1 columnmean) % (<:@:#))
make2d=: 1&,@:$ $ ]
tol=: 1e_6             NB. epsilon, small value



NB. Creates an instance of Gaussian Mixture Model
NB. class. The GMM takes the data model set and number
NB. of components as parameters.
NB. Weights are initialized to be evenly distributed between components.
NB. The mean values are initialized randomly, or initially estimated using
NB. K-means estimator.
NB. y: boxed array of
NB. 0: data set (N * dimensions) shapes.
NB. 1: number of components.
NB. 2: Covariance type: Either 'Full', 'Tied', 'Diag', 'Spherical'
NB. 3: regularization value. This value is added to the covariance 
NB.    matrix / matrices, to prevent overfitting.
NB. 4: perform k-means optimization on initial mean values. 1 if yes,
NB.    0 if no. For large datasets this may be slow.
NB. 5: tolerance value. If change in log-likelihood is less than this value
NB.    between iterations, then the execution of the fit verb will stop.
NB. Example:
NB. >   g=: (X; 3; 'diag'; 1e_5; 1; 1e_6) conew 'GMM'
create=: 3 : 0
'data components covariance reg km tol'=: y
covariance=: tolower covariance
assert. ''-:$reg
assert. reg > 0
assert. +/(<covariance) -:"_ 0 ;:'full tied diag spherical'
dimensions=: ~. #"1 data

if. covariance -: 'full' do.
  covars=: (components, dimensions, dimensions) $, covGM data NB. covariance matrix
  regMat=: reg * ($covars) $, (=@i.) dimensions
elseif. covariance -: 'tied' do.
  covars=: (dimensions, dimensions) $, covGM data
  regMat=: reg * (=@i.) dimensions
elseif. covariance -: 'diag' do.
  covars=: ? (components, dimensions) $ 0 
  regMat=: ($covars) $ reg
elseif. covariance -: 'spherical' do.
  covars=: ?  (components,1) $ 0 
  regMat=: reg
end.

weights=: components#%components
means=: ? (components, dimensions) $ 0
if. km do. means=: initMeans data end.
prevll=: _        NB. previous log-likelihood value, initialized to arbitrary large value
change=: 100      NB. change in the value of the current log-likelihood and prev. value.
completeFit=: 0
)


NB. initialize the means by using K-means to estimate them
NB. more accurately than randomly.
initMeans=: 3 : 0
kmc=: ((({~ ?~@#) y);'euclidean';components; 'uniform') conew 'KMeans'
fit__kmc 20
means__kmc + 0.019 * ? ($means__kmc) $ 0
NB. destroy__kmc ''
)


predict=: 3 : 0 "1

if. 2 > #$ y do. y=. make2d y end.

if. covariance -: 'full' do.
  eStepFull y
elseif. covariance -: 'tied' do.
  eStepTied y
elseif. covariance -: 'diag' do.
  eStepDiag y
elseif. covariance -: 'spherical' do.
  eStepSpherical y
end.
^ (lpr) -"1 1 logprob
)


eStepFull=: 3 : 0
NB. first the summand of -0.5 * (dims*log(2pi) + log(det(covars)))
b0=: (dimensions * LOG2PI) +"0 1 ( ^. | det covars)
NB. then, the exponent summand
iCovars=: ''
try.
  L=: cholesky"2 covars
  iCovars=: dotty"2 L
catch.
  smoutput 'Cholesky decomposition failed during e-step, with full covariance.'
  throw.
end.
b1=: (y-"1 1"_ 1 means) f"1 2 iCovars
lpr=: (^.weights ) + _0.5 * ( ''$ b0) + b1
logprob=: ^. +/ ^lpr
resp=: ^ lpr -"1 1 logprob
)



eStepTied=: 3 : 0
NB. first the summand of -0.5 * (dims*log(2pi) + log(det(covars)))
b0=: (dimensions * LOG2PI) + ( ^. | det covars)
NB. then, the exponent summand
iCovars=: ''
try.
  L=: cholesky covars
  iCovars=: dotty L
catch.
  smoutput 'Cholesky decomposition failed during e-step, with tied covariance.'
  throw.
end.
b1=: (y-"1 1"_ 1 means) f"1 _ iCovars
lpr=: (^. weights) +"1 2 [_0.5 * (''$b0) + b1
logprob=: ^. +/ ^lpr
resp=: ^ lpr -"1 1 logprob
)

eStepDiag=: 3 : 0
I=: (=@i.) dimensions
co=: covars *"1 _ I
iCovars=: %. co

b0=: (dimensions * LOG2PI) +"0 _ ( +/"1^. | covars)
b1=: (y-"1 1"_ 1 means) f"1 2 iCovars
lpr=: (^.weights ) + _0.5 * ( ''$ b0) + b1
logprob=: ^. +/ ^lpr
resp=: ^ lpr -"1 1 logprob
)

eStepDiag2=: 3 : 0
b0=: (dimensions * LOG2PI) +"0 _ ( +/"1^. | covars)
b1=: |:+/"1 (*: y-"1 1"_ 1 means) dot |: % covars
lpr=: (^. weights) +"1 2 |: _0.5 * ,/ b0 +"1 1"1 _ b1
logprob=: ^. +/ ^lpr
resp=: ^ lpr -"1 1 logprob
)


eStepSpherical=: 3 : 0
b0=: (dimensions * LOG2PI) +"0 _ ( +/"1^. | covars)
b1=: |: +/"1 ( *: y-"1 1"_ 1 means)  %, covars
lpr=: (^. weights) +"1 2 |: _0.5 * ,/ b0 +"1 1"1 _ b1
logprob=: ^. +/ ^lpr
resp=: ^ lpr -"1 1 logprob
)






mStepFull=: 3 : 0
means=: (resp dot data) % sumResp
I =: ($covars) $, (=@i.) dimensions
subMeans=: data -"1 1"_ 1 means
covars=: (regMat * I) + sumResp %~ ( (resp * subMeans) dot~"2 2 |:"2 subMeans)
weights=: (#data)%~ (+/"1 resp)
)


mStepTied=: 3 : 0
means=: (resp dot data) % sumResp
s1=: data dot~ |: data
s2=: (sumResp * means) dot~ |: means
covars=: regMat + (#data) %~ s1 - s2
weights=: (#data)%~ (+/"1 resp)
)

mStepDiag=: 3 : 0
means=: (resp dot data) % sumResp
subMeans=: data -"1 1"_ 1 means
covars=:  (<0 1) |:"2 regMat + sumResp %~ ( (resp * subMeans) dot~"2 2 |:"2 subMeans)
weights=: (#data)%~ (+/"1 resp)
)


mStepDiag2=: 3 : 0
means=: (resp dot data) % sumResp
subMeans=: data -"1 1"_ 1 means
NB. take diagonals of FULL covariance case.

covars=: regMat + sumResp %~ (|: (<0 1) |: (resp * subMeans) dot~"2 2 |:"2 subMeans)
weights=: (#data)%~ (+/"1 resp)
)

mStepSpherical=: 3 : 0
means=: (resp dot data) % sumResp
subMeans=: data -"1 1"_ 1 means
covarsx=:  (<0 1) |:"2 regMat + sumResp %~ ( (resp * subMeans) dot~"2 2 |:"2 subMeans)
weights=: (#data)%~ (+/"1 resp)
covars=: (components, 1) $,(+/ % #)"1 covarsx
)

mStepSpherical2=: 3 : 0
means=: (resp dot data) % sumResp
subMeans=: data -"1 1"_ 1 means 
t=:  |: sumResp %~ (|: (<0 1) |: (resp * subMeans) dot~"2 2 |:"2 subMeans)
covars=: regMat + (components, 1) $, (+/ % #) t
weights=: (#data)%~ (+/"1 resp)
)


NB. Calculates the E-STEP responsibilities of each component for
NB. all datapoints in the dataset.
NB. Parameterless verb.
eStep=: 3 : 0
if. covariance -: 'full' do.
  eStepFull y
elseif. covariance -: 'tied' do.
  eStepTied y
elseif. covariance -: 'diag' do.
  eStepDiag y
elseif. covariance -: 'spherical' do.
  eStepSpherical y
elseif. 1 do.
  smoutput 'Unknown covariance type.'
  throw.
end.
)

NB. Calculates the M-STEP responsibilities of each component for
NB. all datapoints in the dataset.
NB. Parameterless verb.
mStep=: 3 : 0
if. covariance -: 'full' do.
  mStepFull ''
elseif. covariance -: 'tied' do.
  mStepTied ''
elseif. covariance -: 'diag' do.
  mStepDiag ''
elseif. covariance -: 'spherical' do.
  mStepSpherical '' 
elseif. 1 do.
  smoutput 'Unknown covariance type.'
  throw.
end.
)


NB. Fit the data to the gaussian model
NB. see: Pattern Maching and Machine Learning, C.M. Bishop, section 9.3
NB. This will run  the given number of iterations of the
NB. E-M algorithm for Gaussian Mixtures and attempt to maximize
NB. likelihood. The final model is given by 'means', and 'covars' parameters,
NB. as well as the 'resp' (responsibilities) parameters.
NB. Arguments:
NB. 0: number of iterations.
NB. 
NB. Example:
NB. >  gmm =: (X; 3; 'diag'; 1e_5; 1; 1e_6) conew 'GMM'
NB. >  fit__gmm 100
NB. ...
NB. >  means__gmm   NB. means
NB. >  covars__gmm  NB. covariance matrix / matrices
NB.
fit=: 3 : 0
assert. y > 0
if. completeFit do.
  smoutput 'Fitting model completed.'
''
  return.
end.

iterations=. y
c=: 0
llList=: ''
while. c < iterations do.
  c=. c + 1
  resp=: eStep data
  sumResp=: +/"1 resp
  mStep ''
  
  newll=: +/ logprob
  llList=: llList, newll
  if. c = 1 do.
    prevll=: newll
  else.
    change=: newll - prevll
    prevll=: newll
  end. 
  if. (|change) < tol do.
    completeFit=: 1
    break. '' end.
end.
change
)

logLikelihood=: 3 : 0
prevll
)

NB. Akaike Information Criterion
NB. NB. Parameters
NB. 0: Log Likelihood value
NB. 1: number of components in the model
NB. Returns
NB. Aikake Information Criterion value for
NB. the selected model.
AIC=: 3 : 0
'L s'=. y
+: components - newll NB. s - L
)

NB. Bayesian Information Criterion
NB. Parameters
NB. 0: Log likelihood value
NB. 1: total number of training examples
NB. 2: number of components in the model
NB. Returns
NB. Bayesian Information Criterion value for
NB. the selected model.
BIC=: 3 : 0
'L h s'=. y
(s * ^. h) - +: h * L
)


NB. A gaussian function based on the estimated mean(s)
NB. and covariance(s) of the model. 
gaussian=: 4 : 0" 0 1
m=: x{means
co=: x{covars
w=: x{weights

b0=: _0.5 * ((dimensions * ^. 2 * PI) +"0 1 ( ^. | det co))
b1=: _0.5*(y-m) f %. co
lpr=: ((^. w) + b0) + b1
^lpr
)

destroy=: 3 : 0
if.-. kmc = '' do. destroy__kmc '' end.
codestroy ''
)

