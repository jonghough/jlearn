Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

require jpath '~Projects/jlearn/mlp/mlpopt.ijs'
require jpath '~Projects/jlearn/utils/utils.ijs'

cocurrent 'MLP'


NB. Multilayer Perceptron classes and functions.
NB. BaseMLP:
NB. Base class for MLPs. Contains the basic forward
NB. and backward operations for a MLP. Backpropagation
NB. can be used with a variety of gradient optimizers,
NB. e.g. SGD, Adam.

coclass 'BaseMLP'

NB. some useful verbs.
dot=: +/ . *				NB. matrix multiplication
make2d=: (1&,@:$ $ ])			NB. make 2-d array
softmax=: (^@:x:@:{) % (+/@:^@:x:@:])		NB. softmax function.
regCoefficient=: 0.01			NB. regularization coefficient
regF=: (#&0)@:#				NB. reg. function


NB. vectorize multiclass labels
extractClasses=. 3 : 0
num=. # ~. y
#: 2^num
)


NB. =========================================================
NB. =================== loss functions ======================
cel=: 4 : 0
ly=. -^.y
(+/ % #) +/"1 x * ly
)

bcel=: 4 : 0
ly=. ^.y
lomy=. ^. 1- y
- (+/ % #) +/"1 (x*ly ) + (1-x) * lomy
)

mse=: 4 : 0
-:(+/ % #)*:x-y
)

NB. =========================================================
NB. ============ activation fn derivatives ==================

NB. Activation functions, and derivatives, for hidden layers.
relu=: 0:`[@.>&0
drelu=: 0:`1:@.>&0

logistic=: %@:>:@:^@:-
dlogistic=: (logistic f.) d. 1

tanh=: 7&o.
dtanh=: (tanh f.) d. 1

identity=: ]
didentity=: 1:"0


NB. diff softmax. Diff for output layers
diffSoftmax=: 3 : 0
sm=: (] % +/ )@:^
theta=: sm"1 y

loss=: expected cel theta
loss=: loss +  batchSize %~ regCoefficient * regF weights

error=: theta-expected
NB.dval=: (sm D. 1)"1 y
delta=: error
)



NB. diff sigmoid. Diff for output layers
diffLogistic=: 3 : 0
theta=: logistic y

loss=: expected bcel theta
loss=: loss + batchSize %~  regCoefficient * regF weights

error=: theta - expected
delta=: error NB. make2d error * dlogistic y
)


diffTanh=: 3 : 0
theta=: (tanh y)

loss=: expected bcel theta
loss=: loss + batchSize %~  regCoefficient * regF weights

error=: theta - expected
delta=: make2d error * dtanh y
)

diffIdentity=: 3 : 0
theta=: identity y

loss=: expected mse theta
loss=: loss + batchSize %~  regCoefficient * regF weights

error=: theta - expected
delta=: error
)

NB. Creates random weights for the matrices for the
NB. given layer sizes.
NB. x: type of activation. Can be
NB.    'logistic'
NB.    'tanh'
NB.    'relu'
NB.    'identity'
NB. y: list of layer sizes.
NB. e.g. if y =. 2 3 3 2
NB. creates 2x4,4x4,4x2 matrices with random
NB. values between 0 and 1. (includes bias nodes)
createRandomWeightsNormal=: 4 : 0
assert. (<x) e. 'logistic';'tanh';'relu';'identity'
dimen=: 2 ((>:@:[),]) /\ y
if. x -: 'logistic' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x -: 'tanh' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(4&*)@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x-: 'relu' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(1.41421)&*@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x-: 'identity' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/)))))&.> <"1 dimen
end.
)


setActivationFunctions=: 3 : 0

NB. =========================================================
NB. ======== Set output layer activation type  ==============

if. activation -: 'logistic' do.
  handleOutputNodes=: diffLogistic
  active=: logistic
  
elseif. activation -: 'softmax' do.
  handleOutputNodes=: diffSoftmax
  active=: (i.@:# softmax ])"1
elseif. activation -: 'identity' do.
  handleOutputNodes=: diffIdentity
  active=: identity
end.

if. hidden -: 'logistic' do.
  sigmoid=: logistic
  dsigmoid=: dlogistic
elseif. hidden -: 'tanh' do.
  sigmoid=: tanh
  dsigmoid=: dtanh
elseif. hidden -: 'relu' do.
  sigmoid=: relu
  dsigmoid=: drelu
elseif. hidden -: 'identity' do.
  sigmoid=: identity
  dsigmoid=: didentity
end.
''
)


NB. =========================================================
NB. ============== regularization functions =================

NB. L1 matrix norm regularization parameter.
regL1=: >./@:+/@:|

NB. L2 matrix norm regularization parameter.
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


setSolver=: 3 : 0
NB. =========================================================
NB. ================= Set solver type  ======================

solvers=: ''
if. solverType -: 'adam' do.
  solvers=: weights conew 'AdamSolver'
elseif. solverType -: 'sgd' do.
  solvers=: alpha conew 'SGDSolver'
elseif. solverType -: 'sgdm' do.
  solvers=: (alpha;0.6) conew 'SGDMSolver'
elseif. solverType -: 'adagrad' do.
  solvers=: weights conew 'AdaGradSolver'
elseif. solverType -: 'rmsprop' do.
  solvers=: weights conew 'RMSPropSolver'
end.

''
)

NB. Initializes an instance of MLPClassifier.
NB. Parameters, in order:
NB. 0: layer sizes, number of nodes in each layer
NB. 1: hidden layer activation functions
NB. 2: activation function name
NB. 3: alpha, learning rate
NB. 4: beta, the loss penalty coefficient
NB. 5: max number of epochs
NB. 6: regularization param
NB. 7: solver, e.g. SGD, Adam etc.
NB. 8: batch size (minimum 1, max is dataset size)
NB.
NB. Example:
NB. Run MLP Classifier on iris dataset. (X,Y) are the training datapoints and labels, respectively.
NB. > C=. ((4 8 8 5 3);'tanh';'softmax'; 0.1; 0.2; 100;'L2'; 'SGD';5) conew 'MLPClassifier'
NB. > Y fit__C X
NB. ...
NB. > predict__C testDatapoint
create=: 3 : 0
'layers hidden activation alpha'=: 4{.y
'beta epochs reg solverType batchSize'=: 4}. y

hidden=: 		tolower hidden
activation=: 	tolower activation
solverType=: 	tolower solverType
reg=: 		tolower reg
assert. ((0&<) *. (1&>)) alpha
assert. +/ (<reg) -:"_ 0 'l1';'l2';'none' NB. regularization L1,L2 or None
assert. +/ (<solverType) -:"_ 0 'adam';'sgd';'sgdm';'adagrad';'rmsprop'
assert. batchSize > 0
assert. (<activation) e. 'logistic';'softmax';'tanh';'identity'
assert. (<hidden) e. 'logistic';'tanh';'relu';'identity'


setActivationFunctions 0
setRegularization 0

NB. =========================================================
NB. ================== Set the weights  =====================

weights=: hidden createRandomWeightsNormal layers

NB. set the solver
setSolver 0
)


NB. Fits the training data to the target output data.
NB. x: target output data
NB. y: training data
fit=: 4 : 0
inputdata=. y
result=. x
sz=. # inputdata
pe=. >. sz % batchSize
ctr=. 0
allLoss=: ''
while. ctr < epochs do.
  ectr=. 0
  while. ectr < pe do.
    reset__solvers ''
    ectr=. ectr+1
    index=: batchSize ?# inputdata	NB. choose random row
    data=. index { inputdata		NB. get the random sample
    expected=: index { result            NB. get expected result for random sample
    theta=: data			NB. theta values give the output of activation func. run on neuron layer.
    allNet=: < data                      NB. store the layer output data (pre-activation func).
    net=: forwardpass ''                 NB. net is the sum output of the final layer
    handleOutputNodes net                NB. calculate the output error and derivative.
    allLoss=: allLoss,loss
    backpropagate ''                  NB. back prop the error through the network.
  end.
  ctr=. ctr+1
end.
theta
)

NB. =========================================================
NB. ==================== Forward pass =======================


NB. forward pass a mini-batch of samples through the MLP
NB. function takes no params as it uses class member variables.
forwardpass=: 3 : 0
for_j. i. # weights do.
  net=. (theta,"(1) 1) dot (>j{weights)
  allNet=: allNet, < net
  theta=: sigmoid net
end.
net
)


NB. =========================================================
NB. ================== Backpropagation ======================


backpropagate=: 3 : 0
allDeltas=: <delta
hErrors=. ''
for_j. |. i. # weights do.
  if. (<:#weights) = j do.
    currentNet=. >(j){ allNet
    cw=. >j{weights
    wg=. ( |: (sigmoid currentNet),"1] 1) dot delta
    wg=. wg + beta * cw
    wg=. wg % batchSize
    hErrors=. hErrors,~<wg
  else.
    cw=. >j{weights
    nextWeight=. >(j+1){ weights 	NB. get next layer's weights.
    deriv=. dsigmoid >(j+1){ allNet	NB. calculate diff. of sigmoid of the next layer output
    delta=: deriv * delta dot |: }: nextWeight
    current_theta=. (>@:{&allNet )`(sigmoid>@:{&allNet )@.(0&<) j
    wg=. (|: current_theta,"1] 1) dot delta	NB. current theta values * delta to give this layer's error gradient
    wg=. wg + beta * cw
    wg=. wg % batchSize
    hErrors=. hErrors,~< wg
  end.
end.
weights=: weights calcGrad__solvers hErrors

)


predict=: 3 : 0 "1
inputdatax=. y
th=. inputdatax
NB. go through the network
NB. and calculate the output
for_j. i. # weights do.
  next=. (|:>j{weights) dot th, 1
  th=. (sigmoid next)
  if. j = <:#weights do.
    th=. active next
  end.
end.
th
)

score=: 4 : 0
assert. x (-:&:({.@:$)) y
vdata=. validate y
NB.
(# y) %~ +/x -:"1 1 (0:`1:@.>&0.5) vdata
)





destroy=: codestroy

Note 1
MLP Regressor is used for regression problems. The output activation
function is simply the 'identity' function. Hidden layer activation
functions can be set to 'identity', 'relu', 'logistic', 'tanh', with
appropriate derivatives.

)
coclass 'MLPRegressor'
coinsert 'BaseMLP'

NB. Initializes an instance of MLPRegressor.
NB. 0: layer sizes, number of nodes in each layer
NB. 1: hidden layer activation functions
NB. 2: alpha, learing rate constant between 0 and 1.
NB. 3: beta
NB. 4: max epochs
NB. 5: regularization param
NB. 6: solver, e.g. SGD, Adam etc.
NB. 7: batch size (minimum 1, max is dataset size)
create=: 3 : 0
if. 8 = # y do.
  'layers hidden alpha beta'=: 4{.y
  'epochs reg solverType batchSize'=: 4}. y
  hidden=: 	tolower hidden
  activation=: 	tolower activation
  solverType=: 	tolower solverType
  activation=: 'identity'
  assert. (<activation) e. <'identity'
  assert. (<hidden) e. 'logistic';'tanh';'relu';'identity'
  (create_BaseMLP_ f. )layers;hidden;activation;alpha;beta;epochs;reg;solverType;batchSize
elseif. 6=#y do.
  'reg hidden activation batchSize solvers weights'=: y
elseif. a:=y do.
  a=. 1
elseif. 1 do.
  'Cannot construct MLPRegressor using ',(": #y), 'args.' throw.
end.
)




destroy=: 3 : 0
try.
  destroy__solvers ''
catch.
  smoutput 'Error destroying MLPRegressor solver'
end.
codestroy ''
)


Note 2
MLP Classifier is used for classification problems. The output activation function
can be set to 'Softmax' or 'Logistic', for either single class sets, or multiclass
sets, respectively.
)



coclass 'MLPClassifier'
coinsert 'BaseMLP'

NB. Initializes an instance of MLPClassifier.
NB. Parameters, in order:
NB. 0: layer sizes, number of nodes in each layer
NB. 1: hidden layer activation functions
NB. 2: activation function name
NB. 3: alpha, learing rate constant between 0 and 1.
NB. 4: beta
NB. 5: max epochs
NB. 6: regularization param
NB. 7: solver, e.g. SGD, Adam etc.
NB. 8: batch size (minimum 1, max is dataset size)
NB.
NB. Example:
NB. > REG=. ((6 5 5 2 1);'tanh';0.1; 0.2; 10000;'L2'; 'SGD';10) conew 'MLPRegressor'
NB. 
create=: 3 : 0
if. a: -: y do.
  ''
else.
  'layers hidden activation alpha'=: 4{.y
  'beta epochs reg solverType batchSize'=: 4}. y
  
  hidden=: 		tolower hidden
  activation=: 	tolower activation
  solverType=: 	tolower solverType
  
  assert. 1<{:layers NB. classification needs more than one class to distinguish.
  assert. (<activation) e. 'softmax';'logistic'
  assert. (<hidden) e. 'logistic';'tanh';'relu';'identity'
  
  
  create_BaseMLP_ f. layers;hidden;activation;alpha;beta;epochs;reg;solverType;batchSize
  0
end.
)

destroy=: 3 : 0
try.
  destroy__solvers ''
catch.
  smoutput 'Error destroying MLPClassifier solver'
end.
codestroy ''
)

 