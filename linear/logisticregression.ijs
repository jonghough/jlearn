Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


NB. Linear Classifier implementation.
NB. http://code.jsoftware.com/wiki/Essays/Linear_Regression 

NB. Logistic Regression Classifier, using Stochastic
NB. gradient descent

Note 'References'
[0] Pattern Recognition and Machine Learning, Bishop. Chapter 4.

)

coclass 'LRC'


NB. Cross Entropy Loss
cel=: 4 : 0
ly=. -^.y
(+/ % #) +/"1 x * ly
)


NB. Binary Cross Entropy Loss
bcel=: 4 : 0
ly=. ^.y
lomy=. ^. 1- y
- (+/ % #) +/"1 (x*ly ) + (1-x) * lomy
)

dot=: +/ .*


setActivation=: 3 : 0
a=. <y
if. y-: 'logistic' do.
  activation=: %@:>:@:^@:-
elseif. y-: 'softmax' do.
  activation=: (] % +/ )@:^  NB.(] % +/ )@:^@:(]-(>./))"1 NB. (] % +/ )@:^ 
end.
NB.activation=: actx NB.(] % +/ )@:^@:(]-(>./))
''
)

actx=: 3 : 0
maxdiff=: (]-(>./)) y
expdiff=: ^ maxdiff
ds=: (] % +/ ) maxdiff
ds
)

regL1=: >./@:+/@:|
regL2=: -:@:(+/@:*:@:,)&:>


setRegularization=: 3 : 0

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


NB. Creates an Instance of LRC class (Linear Regression Classifier).
NB. Linear regression classifier can be used for binomial or multinomial
NB. problems.
NB. Parameters:
NB.   0: input size. The number of features / dimensions of the input set.
NB.   1: output size. The number of classes / labels.
NB.   2: Epochs. The number of epochs to run through the training data.
NB.   3: Solver. (TODO, this is not used fot now. Solver is SGD. In future may 
NB.      implement bfgs or other.
NB.   4: Activation function to use. Can be one of
NB.      Logistic
NB.      Softmax (for multinomial)
NB.   5: Learning rate
NB.   6: Batch size.
NB.   7: Regularization function. Can be one of:
NB.      'none' for no regularization
NB.      'L1' for L1 regularization
NB.      'L2' for L2 regularization
create=: 3 : 0
'is os epochs solver act lr batchSize reg'=: y
act=: tolower act
reg=: tolower reg
'Input size (feature set size) must be greater than zero' assert is > 0
'Output size (Number of classes) must be greater than zero' assert os > 0
'Batch size must be greater than zero' assert batchSize > 0
'Activation function can be logistic or softmax' assert +/ (<act) -:"_ 0 'logistic';'softmax'
'Regularization can be L1, L2 or none' assert +/ (<reg) -:"_ 0 'l1';'l2';'none'
weights=: +: 0.5-~ ? ((is+1),os) $ 0
regCoefficient=: 1e_6
setActivation act
setRegularization 0
bestLoss=: _
lossCache=: ''
''
)


fit=: 4 : 0
epochCtr=. 0
sz=. # y
itMax=: >. sz % batchSize
while.epochs > epochCtr=. epochCtr+1 do.
  iteration=: 0
  while. itMax>iteration=: iteration+1 do.
    r=: batchSize ? # y
    bch=: r{y
    trg=: r{x
    t=: activation"1 (bch,"1[1) dot weights
    loss=: trg cel t
    if. loss < bestLoss do. bestLoss=: loss end.
    lossCache=: lossCache,loss
    weights=: weights + lr * (|:bch,"1[1) dot ((trg - t) - regF weights)
  end.
end.
''
)

predict=: 3 : 0"1
activation (y,"1[1) dot weights
)



accuracy=: 4 : 0
(# x -:"1 1 (=>./)"1 predict y) % #x
)

destroy=: codestroy

Note 'Example'
Example using Linear classifier with linear separable
training data.
Create some data that is easy to verify as being linear separable:

data =: 5 3 $ 0.6 _0.2 _0.99,    0.44 _0.2 _0.4,  _0.5 0.99 _0.1,  _0.233 _0.75 0.69, _0.1 _0.4 0.2
targ =: 5 3 $ 1 0 0 1 0 0 0 1 0 0 0 1 0 0 1

i.e. the positive feature is the class.

LC =: (3;3;25;'gd';'softmax';0.02;3; 'l2') conew 'LRC'
targ fit__LC data
)