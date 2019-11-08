Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 'References'
[1] Understanding the difficulty of training deep feedforward neural networks, Glorot, X., Bengio, B.
link: http://proceedings.mlr.press/v9/glorot10a/glorot10a.pdf

[2] Delving Deep into Rectifiers: Surpassing Human-Level Performance on ImageNet Classification,
Kaiming He et al.
link: https://arxiv.org/pdf/1502.01852v1.pdf
)

require jpath '~Projects/jlearn/mlp/mlpopt.ijs'

NB. This script contains the "NNPipeline", "NNLayer",
NB. and "SimpleLayer" classes.
NB. The "NNPipeline" is the container class for a neural network
NB. model, which may be a densely connected network, a recurrent
NB. network, or a convolutional network (or combination of).
NB. The "NNLayer" proivdes the base class for all layers that
NB. can be added to the neural network model.
NB. For now, all models are linear (no forks, or junctions), and
NB. must end in a densely connected layer, either for regression
NB. or classification models.
NB. The "SimpleLayer" is a densely connected layer, in which
NB. all incoming nodes will be connected to all outgoing nodes.
NB. A simple (densley connected) neural network is also defined
NB. in the ../mlp/basemlp.ijs script, in a less modular way, and
NB. with slightly less functionality.


cocurrent 'NN'

dot=: +/ . *				NB. matrix multiplication
make2d=: (1&,@:$ $ ])			NB. make 2-d array
softmax=: (^@:x:@:{) % (+/@:^@:x:@:])		NB. softmax function.
regCoefficient=: 0.01			NB. regularization coefficient
regF=: (#&0)@:#				NB. reg. function

NB. Clamps the argument in range [-1,1].
NB. Used to prevent exploding gradients.
clamp1=: 3 :0 "0
]`*@.(_1&>)`1:@.(1&<) y
)

NB. Clamps y between {.x and {:x. x is expected to
NB. be a two item list.
NB. example:
NB. > 0 10 clamp 11.1
clamp=: [ ({.@:[ >. ]) {:@:[ <. ]

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
outSoftmax=: 4 : 0
'Y reg bs'=. y
sm=: (] % +/ )@:^
theta=: sm"1 Y

loss=: x cel theta
loss=: loss + reg
error=: theta-x
NB.dval=: (sm D. 1)"1 y
delta=: error
)



NB. diff sigmoid. Diff for output layers
outLogistic=: 4 : 0
'Y reg bs'=. y
theta=: logistic Y

loss=: x bcel theta
loss=: loss + reg

error=: theta - x
delta=: error NB. make2d error * dlogistic y
)


outTanh=: 4 : 0
'Y reg bs'=. y
theta=: tanh Y

loss=: x bcel theta
loss=: loss + reg

error=: theta - x
delta=: error
)


outIdentity=: 4 : 0
'Y reg bs'=. y
theta=: identity Y

loss=: x mse theta
loss=: loss + reg

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
'Activation function unknown.' assert (<x) e. 'logistic';'tanh';'relu';'identity';'softmax'
dimen=: 2 ((>:@:[),]) /\ y
if. x -: 'logistic' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x -: 'tanh' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(4&*)@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x-: 'relu' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(1.41421&*)@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x-: 'identity' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/)))))&.> <"1 dimen
elseif. x-: 'softmax' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/)))))&.> <"1 dimen
end.
)

createRandomWeightsUniform=: 4 : 0
'Activation function unknown.' assert (<x) e. 'logistic';'tanh';'relu';'identity';'softmax'

dimen=. 2 ((>:@:[),]) /\ y 

max=. (%:@:(6&%)@:(+/))&.> <"1 dimen 

max ([ * (<:@:+:@:?@:($&0)@:]))&.><"1 dimen

)

fans=: 3 : 0
if. 2 = # y do. y
NB. else. (1{y), */ (1 -.~ i. # y) { y end.
else. (*/ 1}.y), {.y end.
)

uniform=: 4 : 0
x * <: +: ? y $ 0
)



normal=: 4 : 0
(# */y) bmt_jLearnUtil_ 0;x
)



glorotUniform=: 3 : 0
(%: 6 % +/ fans y) uniform ( y)
)



heUniform=: 3 : 0
1.0 * (%: 6 % {. fans y) uniform ( y)
)



glorotNormal=: 3 : 0
(%: 2 % +/ fans y) normal ( y)
)

NB. Sets the activation function and its derivative.
NB. Activation functions may be any of
NB. softmax
NB. identity
NB. tanh
NB. logistics
NB. relu
NB. Parameters:
NB. 0: activation function name.
NB. returns:
NB.   the gerund form of the activation function and its derivative.
NB.   activation; derivative
NB.
NB. example:
NB. > setActivationFunctions 'relu'
setActivationFunctions=: 3 : 0
'Activation function unknown.' assert (<y) e. 'logistic';'tanh';'relu';'identity';'softmax'
if. y -: 'softmax' do.
  dactf=. outSoftmax
  actf=. (] % +/ )@:^  NB. (i.@:# softmax ])"1
elseif. y -: 'identity' do.
  dactf=. didentity
  actf=. identity
elseif. y -: 'logistic' do.
  actf=. logistic
  dactf=. dlogistic
elseif. y -: 'tanh' do.
  actf=. tanh
  dactf=. dtanh
elseif. y -: 'relu' do.
  actf=. relu
  dactf=. drelu
elseif. 1 do.
  smoutput 'Unknown activation function ',y
  throw.
end.
((actf )`'');((dactf )` '')
)

NB. Sets the gradient optimization solver.
NB. The gradient solver can be any of the following:
NB. Adam (adaptive momentum)
NB. SGD (stochastic gradient descent)
NB. SGDM (SGD with momentum)
NB. RMSProp
NB. parameters:
NB. y: solver name (lower case)
NB. x: parameters needed to initialize the solver. e.g. in
NB.    the case of the adam solver, the weight metrices are
NB.    needed to set the correct size of the internal matrices.
NB. returns:
NB.    the solver object.
setSolver=: 4 : 0

if. y -: 'adam' do.
  x conew 'AdamSolver'
elseif. y -: 'sgd' do.
  0.1 conew 'SGDSolver'
elseif. y -: 'sgdm' do.
  (0.1;0.6) conew 'SGDMSolver'
end.
)




NB. =========================================================
NB. NN Pipeline class. Container for the sequence of NN layers.
NB. =========================================================

coclass 'NNPipeline'
coinsert 'NN'

regL1=: >./@:+/@:|

regL2=: -:@:(+/)@:*:


NB. Sets the regularization function.
NB. This verb takes no parameters and
NB. returns nothing.
NB. It sets the regF verb (regularization function)
NB. to be either 'l2', 'l1', or 'none'.
NB. The regularization verb is used in the error estimate
NB. at each iteration of training.
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

updateError=: [`]@.>

NB. Creates a Pipeline instance.
NB. The pipeline is used to contain the
NB. list of network layers, and provides the error
NB. calculation.
NB. Parameters:
NB. 0: batch size. Should be greater than 0.
NB. 1: Epochs. Number of epochs to run.
NB. 2: Output activation. If the NN pipeline is a classification
NB.    problem solver, then this should be sigmoid or softmax. If
NB.    the NN pipeline is a regression problem solver, then this
NB.    should be identity. In these case the final partial derivative
NB.    calculation simplifies to activation output minus the expected output.
NB. 3: verbose flag. If 0 then no verbose output, else verbose output of error
NB.    rate per iteration.
create=: 3 : 0
if. a: -: y do.
  ''
else.
  'bs epochs output verbose regularization regParam'=: y
  assert. bs > 0
  assert. epochs > 0
  assert. (< tolower output) e. 'softmax';'sigmoid';'identity'
  o=. tolower output
  if. o -: 'softmax' do.
    errorf=: outSoftmax
  elseif. o -: 'sigmoid' do.
    errorf=: outTanh
  elseif. o -: 'identiy' do.
    errorf=: outIdentity
  end.
  assert. regParam > 0
  regCoefficient=: regParam
  reg=: tolower regularization
  setRegularization ''
  total=: 0
  lastLoss=: _
  bestLoss=: _
  lossKeep=: ''
  layers=: ''
end.
)



NB. Adds the layer to the pipeline. If a previous layer
NB. has already been added, the last added layer's next
NB. member will be set to the y argument, and the y, argument's
NB. prev member will be set to the last added layer.
NB. This essentially give s adoubly-linked list
NB. Note that the final added laye rneeds an appropriate
NB. activation function, depending on whether it is a regression
NB. or classification problem that is being solved.
NB. Note that the given layer's input size must equal the
NB. previous layer's output size.
NB.
NB. example:
NB. > N1 =: (4;10;'tanh';'sgd';0.001) conew 'SimpleLayer'
NB. > N2 =: (12;5;'tanh';'sgd',0.001) conew 'SimpleLayer'
NB. > addLayer__pipe N1
NB. > addLayer__pipe N2
NB. The above code is unacceptable because the input size of N2
NB. is 12, but the output size of N1 is 10. For fully-connected
NB. layers (SimpleLayer) this is trivial to udnerstand, but for
NB. more complex layer types it is important to be careful to
NB. declare the correct sizes.
NB.
NB. parameters:
NB. 0: layer object to add.
addLayer=: 3 : 0
n=. y
bs__n=: bs NB. make sure batch size matches
if. layers -: '' do.
  layers=: layers,n
else.
  l=: {:layers
  next__l=: n
  prev__n=: l
  layers=: layers,y
end.
smoutput 'Added ',type__y,'. Network depth is ',(":#layers),'.'
''
)


NB. Calculates the error at the end of a training iteration forward
NB. pass. For example, if errorf verb is mse, mean squared error loss,
NB. then the error will be calculated using mse with expected
NB. results and actual results given.
NB. parameters:
NB. y: actual results of forward pass, i.e. estimated target value(s)
NB. x: Actual target values.
NB. returns:
NB.  y - x loss derivative.
calcError=: 4 : 0
sw=. ''
for_i. i.#layers do.
  l=. i{layers
  sw=. sw, getWeights__l '' 
end.
r=: bs %~ regCoefficient * regF sw
e=. x errorf y;r;bs

lastLoss=: loss
bestLoss=: bestLoss updateError lastLoss
lossKeep=: lossKeep,loss
y-x
)


NB. Fits the training datapaoints to the training labels.
NB. The algorithm will run for the given number of epochs (defined in
NB. NNPipeline constructor) or until the results are sufficiently
NB. accurate.
NB. parameters:
NB. y: training set.
NB. x: training labels
NB. note that x and y must have the same length (row count).
fit=: 4 : 0

NB. test output
l=: {: layers
if. type__l -: 'SimpleLayer' do.
  'Pipeline output must match last layer''s activation.' assert (tolower output)-: activation__l
end.
sz=. # y
pe=: >. sz % bs
ctr=: 0

for_j. i.#layers do.
  l=: j{layers
  onBeginFit__l ''
end.

NB.preRun y{~ bs ?#y

while. ctr <epochs do.
  ectr=: 0
  while. ectr < pe do.
    ectr=: ectr+1
    for_j. i.#layers do.
      l=: j{layers
      onBeginFit__l ''
    end.
    index=. bs ?# y  NB. choose random row(s)
    X=. index { y    NB. get the random sample(s)
    Y=. index { x    NB. corresponding target value(s)
    Y fit1 X
    total=: total + 1
    smoutput 'Iteration complete: ',(":ectr),', total: ',":total
    wd^:1 'msgs'
  end.
  ctr=: ctr+1
end.
)


NB. Predicts the output for the given input. The input should have
NB. the correct shape for the pipeline.
NB. Parameters:
NB. 0: Input datapoint(s) to predict output with.
NB. returns:
NB.    Predicted target value(s) for the given input.
predict=: 3 : 0
for_j. i.#layers do.
  l=: j{layers
  onBeginPredict__l ''
end.
forwardPass y
)

NB. A single forward and backward pass through the neural
NB. network layers.
fit1=: 4 : 0
o=. forwardPass y
e=. x calcError >{: o
backwardPass e
)

NB. Runs through each layer to verify the data is the correct shape and will
NB. throw an exception with an explanation if any layer fails verifying the
NB. input data. The verification could fail because the input was not of the
NB. correct shape, or the layer does not match the previous layer, e.g.
NB. Layer1 outputs data of shape (5,10,10), but Layer2 requires input data
NB. of shape (6,11,11).
preRun=: 3 : 0
try.
  in=. y
  for_j. i.#layers do.
    l=. j{layers
    out=. preRun__l in
    in=. out
  end.
catch.
  smoutput 'Error! Make sure your input data has the correct shape, and make sure consecutive layer''s match.'
  return.
end.
smoutput 'Network Verification ok.'
)

forwardPass=: 3 : 0
in=. y
outs=. ''
for_j. i.#layers do.
  l=. j{layers
  out=. forward__l in
  outs=. outs,<out
  in=. out
end.
outs
)

backwardPass=: 3 : 0
delta=. y NB. output error
for_j. |.i.#layers do.
  l=. j{layers
  delta=. backward__l delta
end.
''
)


destroy=: 3 : 0
for_j. i.#layers do.
  l=. j{layers
  destroy__l ''
end.
codestroy ''
)



NB. Abstract NNLayer class.
coclass 'NNLayer'
coinsert 'NN'

setActivationFunctions=: 3 : 0
'Activation function unknown.' assert (<y) e. 'logistic';'tanh';'relu';'identity';'softmax'
if. y -: 'softmax' do.
  dact=: outSoftmax
  act=: ((] % +/ )@:^)"1  NB. (i.@:# softmax ])"1
elseif. y -: 'identity' do.
  dact=: didentity
  act=: identity
elseif. y -: 'logistic' do.
  act=: logistic
  dact=: dlogistic
elseif. y -: 'tanh' do.
  act=: tanh
  dact=: dtanh
elseif. y -: 'relu' do.
  act=: relu
  dact=: drelu
elseif. 1 do.
  smoutput 'Unknown activation function ',y
  throw.
end.
''
)


type=: ''  NB. type name.
next=: ''  NB. next layer, in pipeline
prev=: ''  NB. previous layer in pipeline
bs=: 1     NB. batch size for training
create=: destroy=: codestroy

NB. Pre-run will run before the actual
NB. training takes place for data shape
NB. validation, and any other validation
NB. steps that might need to be taken.
preRun=: 3 : 0
0
)

NB. forward pass through this layer.
forward=: 3 : 0
NB. run forward pass.
0
)

NB. Backward pass through this layer.
backward=: 3 : 0
NB. run back prop pass
0
)


NB. called before fitting commences. Useful
NB. for cleaning up or reinitializing variables etc.
onBeginFit=: 3 : 0
0
)


NB. called before predict commences. Useful
NB. for cleaning up or reinitializing variables etc.
onBeginPredict=: 3 : 0
0
)

getWeights=: 3 : 0
0
)




NB. Simple Layer for feed-forward neural netwrok.
NB. Fully Connected to previous and next layers.
coclass 'SimpleLayer'
coinsert 'NNLayer'


NB. Creates an instance of SimpleLayer.
NB. Parameters
NB. 0: input size
NB. 1: output size
NB. 2: activation function
NB.    'relu'
NB.    'tanh'
NB.    'logistic'
NB.    'identity'
NB. 3: solver
NB.    'sgd'
NB.    'sgdm'
NB.    'adam'
NB. 4: Learning Rate
NB. Example
NB. > layer=: (4;5;'relu';'sgdm';0.01) conew 'SimpleLayer'
create=: 3 : 0
if. a: -: y do.
  ''
else.
  'in out activation solverType learnRate'=: y
 NB. w=: 1.2 * ,/>activation createRandomWeightsNormal in, out
   w =:  glorotUniform (>:in),out
  solver=: (<w) setSolver tolower solverType
  e__solver=: learnRate
  next=: ''
  prev=: ''
  isLast=: 0
  setIsLast=: 0
  type=: 'SimpleLayer'
end.
)

preRun=: 3 : 0
try.
  forward y
catch.
  smoutput 'Error in pre run of SimpleLayer.'
  smoutput 'Shape of input was ',": $y
  smoutput 'Shape of weights is ', ": $w
  throw.
end.
)

NB. Forward pass through this layer.
NB. Parameters
NB. 0: previous layer's output.
forward=: 3 : 0
i=: y
n=: (y,"1] 1) dot w
)

NB. Backpropagation call.
NB. The previous layer's delta (or output delta, for final
NB. layer) is given. delta is dot-multiplied by the input to give
NB. weight gradient, and dot-multiplied with this layer's weight
NB. and multiplied by the derivative of the activation
NB. function of the previous layer's output, to produce a new delta.
NB. The new delta is returned.
NB.
NB. Parameters
NB. 0: previous layer's delta
NB. returns:
NB.    new delta
backward=: 3 : 0
delta=. y
wg=. (|: i,"1[1) dot delta
delta=. delta dot |: }: w
wg=. wg % bs
w=: > (<w) calcGrad__solver <wg
delta
)


onBeginFit=: 3 : 0
''
)

onBeginPredict=: 3 : 0
''
)

getWeights=: 3 : 0
,w
)



destroy=: 3 : 0
try.
  destroy__solver ''
catch.
  smoutput 'Error destroying gradient solver for Simple Layer'
end.
codestroy ''
)
