Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[1] Gaussian Processes for Machine Learning, Rasmussen & Williams
link: http://www.gaussianprocess.org/gpml/chapters/RW.pdf

[2] Pattern Recognition and Machine Learning, Cristopher M. Bishop

[3] Scikit-Learn Gaussian Process Classifier
link: https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/gaussian_process/gpc.py

[4] Scikit-Learn Gaussian Process Regressor
link: https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/gaussian_process/gpr.py

[5] Machine Learning, An Algorithmic Perspective 2nd Ed., Stephen Marsland
)

load 'math/lapack'
load 'math/lapack/potrf'
load '~Projects/jlearn/optimize/conjugategradient.ijs'




Note 'Example'
Assume A is the training input data, with corresponding
outputs, t . Use the square Exponential kernel and
initialize the parameters to 1 1 1.

gp=: (A;t;1;'expSquared') conew 'GPBase'

Next, we can use the fit verb to optimize the hyperparameters.
optimize__gp gp; _1 _2 _1

Finally, we can predict the output for some value.
predict__gp 0.1 0.5 0.7 0.1
)

coclass 'GPBase'

trace=: +/@:((<0 1)&|:)		NB. trace of matrix
diag=: (<0 1)&|:	                   NB. diagonal of matrix
dot=: +/ .*
variance=: (+/@(*:@(] - +/ % #)) % #)"1





cholesky=: potrf_jlapack_

kernelConstant=: 3 : 0
'd1 d2 theta'=. y
1 1 $ ,{.theta
)

kernelLinear=: 3 : 0
'd1 d2 theta'=. y
'sigL'=. 1{ theta
(^sigL) * d1 (+/ . *) |: d2
)

kernelExpSquared=: 3 : 0
'd1 d2 theta'=. y
'sigF sigL'=. 2{.theta
I=: (=@i.) #d1
s=. -:- (^ sigL) * (+/"1) (*: d1 -"1 1"1 _ d2)
(^sigF) * ^ s
)



NB. Instantiate a GPBase object.
NB. The parameters are:
NB. 0: training input dataset
NB. 1: training target values, corresponding to the input dataset
NB. 2: hasNoise flag. If true, then noise will be added, with
NB. a corresponding noise hyperparameter.
NB. 3: kernel function choice. Must be a string literal of one of
NB. 	expSquared: square exponential kernel
NB.	linear: linear kernel
NB.	constant: constant kernel
NB. 4: optimizer algorithm:
NB.	'lbfgs' for L-BFGS or
NB.       'cg' for conjugate gradient
NB. 5: maximum iterations. Must be a positive integer
NB. 6: tolerance. Must be greater than 1e_7
create=: 3 : 0
if. y -: a: do.
  '' return.
end.
'trainX trainY hasNoise kernel optimizer maxIter tol'=: y
kernel=: tolower kernel
optimizer=: tolower optimizer
theta=: 0 0 0
assert. (#trainY) = #trainX
assert. hasNoise e. 0 1
assert. (<kernel) e. 'expsquared';'linear';'constant'
assert. (<optimizer) e. 'lbfgs';'cg';'nm'
assert. maxIter > 0
assert. tol > 1e_7
if. (<kernel) -: <'expsquared' do.
  kf=: kernelExpSquared
elseif. (<kernel) -: <'linear' do.
  kf=: kernelLinear
elseif. 1 do.
  kf=: kernelConstant
end.
alpha=: 1e_2
this=: coname ''
''
)

NB. Predict the output value for
predict=: 3 : 0
testX=. y
sigN=. 2{theta
K=. 	kf trainX;trainX;theta
I=. (=@i.) #K
K=. K + alpha*I

if. hasNoise do.
  err=. (^sigN) * I
  try. L=. cholesky K + err
  catch.
    smoutput 'Cholesky decomposition failed '
  end.
else.
  L=. cholesky K
end.
ks=. kf trainX;testX;theta
kss=. kf testX;testX;theta

v=. (%. L) dot ks
var=. kss - (|: v) dot v
invK=. (|: %. L) dot (%.L)
mean=. (|: ks) dot invK dot (trainY)
mean;var
)


NB. Monadic Verb. Fits the hyperparameters to the kernel function,
NB. such that the hyperparameters will maximize the log-likelihood.
NB. The hyperparameters will be found by the conjugate gradient
NB. method. The optimal parameter search has a high chance of failure,
NB. e.g. inverting the kernel matrix. Multipl attempts will be made
NB. to find optimal params.
NB. Note that the optimal params will be locally optimal and not
NB. necessarily global optimal parameters.
NB. Params:
NB. 0: hyperparameter 0
NB. 1: hyperparameter 1
NB. 2: hyperparameter 2
NB. Returns:
NB. optimally found hyperparameters.
NB. Example:
NB.   > myGaussianProcess = (X;Y;1;'expSquared';'cg';1e3;1e_3) conew 'GPBase'
NB.   > fit__myGaussianProcess 2 _1.5 0.5
NB.
fit=: 3 : 0
assert. 3=#y
theta=: y
search=. y
try.
  if. optimizer -: 'cg' do.
    theta=: minCGX_jLearnOpt_ this;y;maxIter;tol;'fr'
NB. theta=: minNelderMeadX_jLearnOpt_ this;y;maxIter;tol;'fr'
NB.theta=: minLBFGSX_BFGS_ this;y;maxIter;tol;0.01
  elseif. optimizer -: 'lbfgs' do.
    theta=: minLBFGSX_jLearnOpt_ this;y;maxIter;tol;0.01
  elseif. optimizer -: 'nm' do.
    theta=: minNelderMeadX_jLearnOpt_ this;y;maxIter;tol;'fr'
  elseif. 1 do.
    throw. 'Unknown optimizer.'
  end.
catcht.
  smoutput 'Failed fitting hyperparameters from start values ',":search
end.
)


NB. Gives the log posterior probability for the given hyperparameters on the
NB. training data and the given Kernel function.
logLikelihood=: 4 : 0
ltheta=. y
'data t'=. x
'sigF sigL sigN'=. ltheta
K=. kf data;data;ltheta
I=. (=@i.) #K
K=. K+ alpha*I
if. hasNoise do.
  err=. (^sigN) * I
  try. L=. cholesky K + err
  catch.
    smoutput 'Cholesky decomposition failed'
    throw.
  end.
else.
  L=. cholesky K
end.

invk=. ''
try.
  invk=. (|: %. L) dot (%.L)
catch.
  smoutput 'Failed to invert lower triangular Matrix.'
  throw.
end.

p1=. ((|: t) dot invk) dot t
p2=. (+/ ^. diag L) + (#data) * (^. +: o.1)
-:-(p1 + p2)
)



NB. Gradient of the log posterior.
gradLogLikelihoodExpSquared=: 4 : 0
ltheta=. y
'data t'=: x
'sigF sigL sigN'=. ltheta
sum=. kf data;data;ltheta
I=. (=@i.) #sum
sum=. sum+ alpha*I
err=. (^sigN) * I
kp=. sum
if. hasNoise do.
  K=. sum + err
else.
  K=. sum
end.

try. L=. cholesky K
catch.
  smoutput sigF ,sigL, sigN
  smoutput K
  smoutput 'Cholesky decomposition failed '
  throw.
end.

try.
  invk=. (|: %. L) dot (%.L)
catch.
  smoutput 'Failed to invert lower triangular Matrix.'
  throw.
end.

dkdsf=. kp
dkdsl=. kp * --: (^ sigL) * (+/"1) (*: data -"1 1"1 _ data)
dkdsn=. (^sigN) * I

Lmx=. (|: t) dot invk
Rmx=. invk dot t

NB. derivative of each hyperparameter w.r.t. the log posterior.
diff=. -:@:((Lmx&dot@:dot&Rmx) - trace@:(invk&dot))
Df=. diff dkdsf
Dl=. diff dkdsl
if. hasNoise do.
  Dn=. diff dkdsn
else.
  Dn=. 0
end.
,Df,Dl,Dn
)





gradLogLikelihoodLinear=: 4 : 0
ltheta=. y
'data t'=: x
'sigF sigL sigN'=. ltheta
sum=. kf data;data;ltheta
I=. (=@i.) #sum
sum=. sum+ alpha*I
err=. (^sigN) * I
kp=. sum
if. hasNoise do.
  K=. sum + err
else.
  K=. sum
end.

try. L=. cholesky K
catch.
  smoutput 'Cholesky decomposition failed '
  throw.
end.

try.
  invk=. (|: %. L) dot (%.L)
catch.
  smoutput 'Failed to invert lower triangular Matrix.'
  throw.
end.



dkdsf=: 0
dkdsl=: (^ sigL) * data (+/ .*) |: data
dkdsn=: (^sigN) * I

Lmx=. (|: t) dot invk
Rmx=. invk dot t

NB. derivative of each hyperparameter w.r.t. the log posterior.
diff=. -:@:((Lmx&dot@:dot&Rmx) - trace@:(invk&dot))
Dl=. diff dkdsl
if. hasNoise do.
  Dn=. diff dkdsn
else.
  Dn=. 0
end.
,0,Dl,Dn
)



gradLogLikelihoodConstant=: 4 : 0
ltheta=. y
'data t'=: x
'sigF sigL sigN'=. ltheta
sum=. kf data;data;ltheta
I=. (=@i.) #sum
sum=. sum+ alpha*I
err=. (^sigN) * I
kp=. sum
if. hasNoise do.
  K=. sum + err
else.
  K=. sum
end.

try. L=. cholesky K
catch.
  smoutput 'Cholesky decomposition failed '
  throw.
end.

try.
  invk=. (|: %. L) dot (%.L)
catch.
  smoutput 'Failed to invert lower triangular Matrix.'
  throw.
end.
 

dkdsf=: 0
dkdsl=: sigL
dkdsn=: (^sigN) * I

Lmx=. (|: t) dot invk
Rmx=. invk dot t

NB. derivative of each hyperparameter w.r.t. the log posterior.
diff=. -:@:((Lmx&dot@:dot&Rmx) - trace@:(invk&dot))
Dl=. diff dkdsl
if. hasNoise do.
  Dn=. diff dkdsn
else.
  Dn=. 0
end.
,0,Dl,Dn
)

NB. Wrapper verb for the logPosterior function. This is needed
NB. by the optimizer (conjugate gradient optimizer) along with
NB. the derivative function's wrapper verb to find optimal
NB. hyperparameters (i.e. hyperparameters which maximize the
NB. log-likelihood)
func=: 3 : 0
-(trainX;trainY) logLikelihood y
)

NB. Wrapper verb for the gradient of the logPosterior function.
NB. This is needed by the optimizer (conjugate gradient
NB. optimizer) to find optimal hyperparameters.
fprime=: 3 : 0
if. (<kernel) -: <'expsquared' do.
  -(trainX;trainY) gradLogLikelihoodExpSquared y
elseif. (<kernel) -: <'linear' do.
  -(trainX;trainY) gradLogLikelihoodLinear y
elseif. 1 do.
  -(trainX;trainY) gradLogLikelihoodConstant y
end.
)

destroy=: codestroy



NB. === UNDER CONSTRUCTION ===
coclass 'GPClassifier'
coinsert 'GPBase'


create=: 3 : 0

)


fit=: 3 :0

)

NB. see [1] page 46, Algorithm 3.1
findMaxLogPosterior=: 3 : 0

sig=. %@:<:@:^@:-
f=. ($trainY)$0
lenTy=. #trainY
Id=. (=@i.) # f
logML=. __
assert. 2=#$f NB. must be a 2-d linear array
it=. 0
while. it < 100 do.
  it=. >: it
  pi=. sig f
  W=. pi * 1 - pi
  Ws=. |: %: W
  L=. cholesky Id + Ws *"_ 1"1 _ K *"1 _"_ 1 Ws
  
  b=. |:( W *f) + (trainY-pi)
  invK=. (%.|: L) dot (%. L)
  a=. ,/ b -"_ 1"1 _ ,/Ws *"_ 1"1 _ |: invK dot ,/ (Ws*"_ 1"1 _ K) dot |: b
  f=. |: K dot |:a
  lml=. -(-:a dot |:f)+(+/^.(1+^(-(trainY*2)-1) *|:f)) + +/ ^. diag L
  if. lml - logML < 1e_10 do.
    break.
    
  end.
  
end.
)

destroy=: codestroy