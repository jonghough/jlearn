Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[0] Batch Normalization: Accelerating Deep Network Training by Reducing Internal Covariate Shift, Sergey Ioffe, Christian Szegedy
link: arXiv:1502.03167

[1] Deep Learning, Bengio et al, Ch. 8.
link:http://www.deeplearningbook.org
)


coclass 'BatchNorm'
coinsert 'NNLayer' 

mean=: +/ % #
variance=: (+/@(*:@(] - +/ % #)) % #)"1

NB. Creates an instance of 'BatchNorm' class. Batch Normalization
NB. objects are used by fully-connected neural net layers,
NB. before the activation function is run. For Convolution
NB. layers BatchNorm2D is used.
NB. To use with a Fully-connected layer, set the 'BatchNorm' flag in 
NB. the layer's constructor to 1.
NB. The BatchNorm has two modes, Fit and Inference. 'Fit' mode is
NB. used in training, in which the beta (bias) and gamma (scale)
NB. parameters are learned, and the loss error gradient is back-
NB. propagated. In 'Inference' mode, the network is used for
NB. prediction, and the forward pass through the BatchNorm is slightly
NB. different to training. The input values are scaled and shifted to
NB. the sample mean and variance of the input data. 
NB. Parameters:
NB. 0: Beta initial value. Beta is the value that the output is
NB.    values ar eshifted by. The value is learned through training,
NB.    by gradient descent.
NB. 1: gamma initial value. Gamma is the scale value. Output data
NB.    is scaled by gamma. This value is also learned through training.
NB. 2: epsilon value. Small value (e.g. 1e_3) that is not learned.
NB. 3: number of dimensions in the output. Beta and gamma will be given this
NB.    length, as training is independent for each dimension.
NB. 4: Learning rate. Current BatchNorm used only SGD to learn beta and
NB.    gamma. e.g. no Adam, RMSprop etc.
NB. example:
NB. myBatchNorm = (0.001;0.001;0.0001;0.01) conew 'BatchNorm'
create=: 3 : 0
smoutput 'batchnorm ',":y
if. a: -: y do.
''
else.
'b g epsilon d lr'=: y
beta=: d # b
gamma=: d # g 
forward=: forwardPassFit 
meanList=: ''
varList=: ''
varCoeff=: ''    NB. coefficient
listMaxSize=: 10 NB. hardcode for now.
type=: 'BatchNorm'
''
end.
)




NB. Forward pass the output of a single neural net layer,
NB. which is then to be processed by the activation function 
NB. for that layer. This pass is use donly for 'Fitting' and
NB. not for 'Inference'. 
NB. See Algoriothm 1 [0]
forwardPassFit=: 3 : 0
i=: y
varCoeff=: (%<:)`1:@.(1&=){.$i
NB. calculate mean and variance of the data.
M=: mean i
V=: variance |: i
meanList=: meanList,<M
varList=: varList,<V
if. (#meanList) > listMaxSize do. meanList=: }.meanList end.
if. (#varList) > listMaxSize do. varList=: }.varList end.
NB. subtract mean from each datapoint.
mdiff=: (i -"1 _ M)
NB. the ihat value is used in backprop, so must be remembered.
ihat=: mdiff %"1 _ (%: V +epsilon)
NB. scale and shift the output.
t=: beta +"_ 1 gamma *"_ 1 ihat
)

NB. Forward pass through the BatchNorm instance for
NB. prediction (inference). The behaviour for inference is
NB. different to the behaviour for training. We are estimating
NB. the mean and variance of the dataset (each feature is 
NB. regarded independently), and using the estimates to
NB. transform the input data.
forwardPassPredict=: 3 : 0
NB. Assume, for now, E[mean] =: M and E[var]=:V
NB. see [0] Algorithm 2, line 11.
expV =: varCoeff * mean&:> varList
expM=: mean&:> meanList
denom=. %%:expV+epsilon
( beta - denom * gamma * expM ) +"_ 1 y *"1 _ gamma *"_ 1 denom
)



backward=: 3 : 0 
backwardPass i;y
)

NB. Backward pass is used in the training phase, and has two 
NB. purposes:
NB. 1. Train the beta and gama values, using gradient descent.
NB. 2. backpropagate the error to the nn layer.
NB. Parameters:
NB. 0: The input values. This is the sae values that were input
NB.    to the forward pass. The derivative is to be calculated
NB.    at this point.
NB. 1: loss gradient. 
NB. returns:
NB.    backpropped loss gradient.
backwardPass=: 3 : 0
'input grad'=: y
NB. learn beta and gamma.
dihat=: grad *"1 _ gamma
dbeta=: +/ grad
dgamma=: +/ grad * ihat
beta=: beta - lr * dbeta 
gamma=: gamma - lr * dgamma

NB. calculate gradient. mdiff is cached from forward pass.
dvar=: (+/ dihat * mdiff* _0.5) *"1 _ (_1.5 ^~ (V + epsilon))
size=: # i
dmean=: (+/ dihat *"1 _ [ _1.0 % %:(V + epsilon)) -"_ 1 [ 2 * dvar *"_ 1 +/ mdiff % size
di=: (dihat %"1 _ (%: V + epsilon)) + (2 * dvar *"_ 1 (mdiff % size) ) +"1 _ dmean % size
)


onBeginFit=: 3 : 0
forward=: forwardPassFit
''
)

onBeginPredict=: 3 : 0
forward=: forwardPassPredict
''
)
 

destroy=: codestroy



NB. BatchNorm for convolution layers. Performs the same function as
NB. 'BatchNorm', but for 4D data, instead of 2D data:
NB. BatchSize x OutputDepth x Width x Height.
NB. The BatchNorm2D essentially flattens the datas and into shape:
NB. OutputDepth x(BatchSize * Width * Height) 
NB. and perofrms standard batch normalization for each output channel.

coclass 'BatchNorm2D'
coinsert 'BatchNorm'  

create=: 3 : 0
if. a: -: y do.
''
else.
create_BatchNorm_ f. y
''
end.
type=:'BatchNorm2D'
)


NB. Forward pass through ther BatchNorm2D object. 
NB. The input is scaled and shifted. Complication is
NB. due to the fact that input datapoints are of the shape
NB.    BatchSize x Channels x Width x Height.
NB. whereas we need one beta and gamma value per channel,
NB. so must rearrange dimensions and flatten.
NB. i.e. Change the shape of the input to
NB.    Channels x (BatchSize * Width * Height)
NB. After all calculations are complete, the value has to be
NB. de-flattened and rearranged to the original shape.
forwardPassFit=: 3 : 0
i=: y
ix=: (({. , (*/@:}.))@:$ $ ,) 1 0 2 3 |: i NB. reshape
subshape=: 0 2 3 { $ i
ixx=: |: ix
outx=:(forwardPassFit_BatchNorm_ f.) ixx 
t=: 1 0 2 3 |: (subshape&$)"1 |: outx
)


NB. Forward pass through the BatchNorm2D instance for
NB. prediction (inference). The behaviour for inference is
NB. different to the behaviour for training. We are estimating
NB. the mean and variance of the dataset (each feature is 
NB. regarded independently), and using the estimates to
NB. transform the input data.
forwardPassPredict=: 3 : 0 
i=: y
ix=: (({. , (*/@:}.))@:$ $ ,) 1 0 2 3 |: i NB. reshape
subshape=: 0 2 3 { $ i
ixx=: |: ix
outx=:(forwardPassPredict_BatchNorm_ f.) ixx
t=: 1 0 2 3 |: (subshape&$)"1 |: outx
)



NB. Backward pass.
backwardPass=: 3 : 0
'input grad'=: y

subshape=: 0 2 3 { $grad
grad=: (({. , (*/@:}.))@:$ $ ,) 1 0 2 3 |: grad
gr=: |: grad
di=: (backwardPass_BatchNorm_ f.) input;gr

1 0 2 3 |: (subshape&$)"1 |:di
)


setFit=: 3 : 0
forward=: forwardPassFit
''
)

setPredict=: 3 : 0
forward=: forwardPassPredict
''
)

destroy=: codestroy