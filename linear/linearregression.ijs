Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


NB. Linear Regression Solver. Uses batch sgd to solve
NB. linear regression problems.
coclass 'LinearRegressor'


dot=: +/ .*


NB. =========================================================
NB. ============== regularization functions =================

NB. L1 matrix norm regularization parameter.
regL1=: >./@:+/@:|

NB. L2 matrix norm regularization parameter.
NB. use lapack
regL2=: -:@:(+/@:*:@:,)&:>

setRegularization=: 3 : 0
NB. =========================================================
NB. ================ Set regularization  ====================

if. reg -: 'l2' do.
  regF=: regCoefficient&*@:regL2
elseif. reg -: 'l1' do.
  refF=: regCoefficient&*@:regL1
elseif. reg -: 'none' do.
  regF=: 0:
elseif. 1 do.
  regF=: 0:
end.
''
)


NB. Creates an instance of the LinearRegressor class.
NB. LinearRegressor uses gradient descent to find optimal
NB. parameters for the liner regression model for a given
NB. dataset.
NB. Parameters:
NB. 0: Input dimensional size. i.e. the feature space size of the dataset. 
NB. 1: Epochs. Number of epochs to perofrm. One epch is essentially
NB.    one iteration through the whole dataset, where a single iteration
NB.    uses the given 'batchSize' number of samples.
NB. 2: Learning rate
NB. 3: Batch Size. One iteration uses this number of samples, chosen randomly 
NB.    from the dataset.
NB. 4: regularization type. Must be one of:
NB.    'l1' for L1 regularization;
NB.    'l2' for L2 regularization;
NB.    'none' for no regularization.
create=: 3 : 0
'is epochs lr batchSize reg'=: y
reg=: tolower reg
assert. batchSize > 0
assert. +/ (<reg) -:"_ 0 'l1';'l2';'none'
os=: 1 NB. output size.
weights=: +: 0.5-~ ? ((is+1),os) $ 0
regCoefficient=: 0.001
setRegularization 0
''
)

NB. Fits the training data to the training labels. The 
NB. operation uses gradient descent, based on the MSE
NB. loss of the output. The forward and backward passes
NB. use the predefined batchsize to run parallel batches. 
NB. Parameters:
NB. x: Target values
NB. y: Training input
fit=: 4 : 0
'Dataset must be 2-dimensional.' assert 2=#$y
'Target values must be 2-dimensional.' assert 2=#$x
c=. 0
sz=: # y
pe=: >. sz % batchSize
while. c <epochs do.
  ectr=. 0
  while. ectr < pe do.
    ectr=. >: ectr
    r=: batchSize ? # y
    bch=: r{y
    trg=: r{x
    c=. c+1
    t=: (bch,"1[1) dot weights
    weights=: weights - lr * (|:bch,"1[1) dot ((t - trg) - regF weights)
  end.
end.
)

predict=: 3 : 0"1
(y,"1[1) dot weights
)

destroy=:codestroy

