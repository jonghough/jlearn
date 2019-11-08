Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 'References'
[1] Deep Learning, Ian Goodfellow, Yoshua Bengio, Aaron Courville
link: http://www.deeplearningbook.org/

[2] A guide to convolution arithmetic for deep learning,
Vincent Dumoulin, Francesco Visin
link: https://arxiv.org/pdf/1603.07285.pdf

[3] Pattern Recognition and Machine Learning, Cristopher M. Bishop

[4] Delving Deep into Rectifiers: Surpassing Human-Level Performance on ImageNet Classification,
Kaiming He, Xiangyu Zhang, Shaoqing Ren, Jian Sun
link: https://arxiv.org/pdf/1502.01852v1.pdf
)

cocurrent 'NN'

NB. Convolution Layer for 2D input e.g. image data. Although the
NB. input is considered 2D, it is essentially split into channels,
NB. e.g. R,B,G channels in preprocess, making the actual input 3D.
NB. Since input into the layer will be provided as batches of the
NB. input data, we take 4D input of shape:
NB.
NB. batch-size X channel-count X width X height.
NB.
NB. The output will also be 4D, of shape
NB.
NB. batch-size X output-channel-count X next-width X next-height.


coclass 'Conv2D'
coinsert 'NNLayer'

relu=: 0:`[@.>&0
drelu=: 0:`1:@.>&0
dot=: +/ . *
rot90=: |.@:|:"2
conv=: ;.3
convFunc=: +/@:,@:*

NB. Creates random weights of the desired shape using a normal distribution with mean
NB. 0 and the variance depending on the type of activation function. This is beased on
NB. Xavier initialization of weight params.
NB. Parameters:
NB. y: Shape fo weights.
NB. x: Activation function - one of:
NB.    'logistic'
NB.    'tanh'
NB.    'relu'
NB.    'identity'
NB.    'softmax'
NB. returns:
NB.    random weights of shape y
createRandomWeightsNormal=: 4 : 0
'Activation function unknown.' assert (<x) e. 'logistic';'tanh';'relu';'identity';'softmax'

if. x -: 'logistic' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/@:(2&{.)))))) y
elseif. x -: 'tanh' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(4&*)@:%:@:(2&%@:(+/@:(2&{.)))))) y
elseif. x-: 'relu' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:(1.41421&*)@:%:@:(2&%@:(+/@:(2&{.)))))) y
elseif. x-: 'identity' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/@:(2&{.)))))) y
elseif. x-: 'softmax' do.
  ($ (*/@:] bmt_jLearnUtil_ (0&,@:%:@:(2&%@:(+/@:(2&{.)))))) y
end.
)

createRandomWeightsUniform=: 4 : 0
'Activation function unknown.' assert (<x) e. 'logistic';'tanh';'relu';'identity';'softmax'

if. x -: 'logistic' do.
   (%:  6 % +/ 2{.  y) * <:+:? y $ 0
elseif. x -: 'tanh' do.
   4 * (%:  6 % +/ 2{.  y) * <:+:? y $ 0
elseif. x-: 'relu' do.
   1.41421 * (%:  6 % +/ 2{.  y) * <:+:? y $ 0
elseif. x-: 'identity' do.
   (%:  6 % +/ 2{.  y) * <:+:? y $ 0
elseif. x-: 'softmax' do.
   (%:  6 % +/ 2{.  y) * <:+:? y $ 0
end.
)

NB. Creates an instance of 'Conv2D'. The instacne can be added to
NB. a 'NNPipeline' instances layers, and is used to convolve 2-d data
NB. Data is expected to be 3d (bxwxhxchannels). For example, image data
NB. might have batch-size x width x height x 3, one channel for each of rgb.
NB. The layer's filter is 4d and is of shape
NB.     depth-of-output x depth-of-input x width x height
NB. The layer, when convolving input, will return an output of
NB.     batch-size x depth-of-output x width' x height'
NB. where widht' and height' are calculated form the convolutions.
NB. Parameters:
NB. 0: shape of filter (depth-of-output x depth-of-input x width x height)
NB.    From the shape, the kernel is defined. The kernel size:
NB.    Should have shape 2 3, where the elements are
NB.     stride       | stride        | stride
NB.     -------------+---------------+--------------
NB.     depth-input  | width         | height
NB. 1: convolution stride. This is the stride between successive convolutions
NB.    of the input tensor with the filter tensor.
NB. 2: activation type. Used to select initialization of weights. Can be one of
NB.     'relu'
NB.     'logistic'
NB.     'tanh'
NB.     'identity'
NB. 3: solver
NB.     'sgd'
NB.     'sgdm'
NB.     'adam'
NB. 4: learning rate.
NB. 5: Gradient Clamp flag. If zero, then no gradient clamping, otherwise
NB.    gradient will be clamped in range [clampLow, clampHigh].
NB.    Default clamp range is [-1,1]. 
create=: 3 : 0
if. a: -: y do.
  bias=: ''
  ''
else.
  'shape stride activation solverType alpha clampFlg'=: y
  assert. 4 = # shape NB. wxhxdinxdout
  assert. 1 <: stride
  assert. alpha > 0
  ks=: 2 3 $ (3 # stride) ,}.shape     NB. kernel shape 
  filter=: glorotUniform shape 
NB.filter=: activation createRandomWeightsNormal shape 
  reordered=: 1 0 2 3 |: filter
  setActivationFunctions activation
  solver=: (<filter) setSolver tolower solverType
  e__solver=: alpha
  bias=: ''
  clampLow=: _1
  clampHigh=: 1
  clampV=: ]
  if. clampFlg do. clampV=: clamp end.
  type=: 'Conv2D'
end.
)

NB. Pre run through the layer.
preRun=: 3 : 0
'Input data has incorrect shape. Must be 4-d.' assert 4=#$y
try.
  cf=: [: |:"2 [: |: [: +/ ks filter&(convFunc"3 3);._3 ]
  r=: cf"3 y
  n=: r
NB. first forward pass. We need to build bias tensor.
  if. bias -: '' do.
    bias=: <:+: ? (1 2 { $ n) $ 0
    solver=: (<filter) setSolver tolower solverType
    e__solver=: alpha
  end.
catch.
  smoutput 'Error in pre-run of conv2d layer.'
  smoutput 'Input data was of shape ',": $ y
  throw.
end.
)

NB. Convolution in forward direction. Convolves the the input (y)
NB. with the filter, using windows of shape x.
NB. This is called during the forward pass.
NB. Parameters:
NB. y: input to the convolution layer. (shape: batchsize x channelcount x width x height)
NB. x: convolution kernel shape (shape: 2x3)
cf=: 4 : 0
|:"2 |: +/ x filter&(convFunc"3 3);._3 y
)

NB. Convolution in backwards direc tion. Convolved the input (y) with the
NB. transformed filter, using windows of shape x.
NB. This is called during the backward pass.
NB. Parameters:
NB. y: transformed input into the backward pass. The input will be padded
NB.    between elements to increase size and make the backward convolution fit
NB. x: The backward pass convolution window size.
bcf=: 4 : 0
|:"2 |: +/ x (1 0 2 3 |: filter)&(convFunc"3 3);._3 y
)

NB. Forward pass through the layer. This function takes the
NB. input tensor and convolves it with the filter, to give an output
NB. tensor of same dimensionality as the input.
NB. The output is passed to the activation function and returned.
NB. Parameters:
NB. 0: Input tensor, must be 4-dimensional, of shape:
NB.    batch-size x channel x width x height
NB. Returns:
NB.    Output tensor of same dimensionality as input, but different
NB.    shape, depending on the convolution algorithm.
forward=: 3 : 0"_
i=: y
'Input data has incorrect shape. Must be 4-d.' assert 4=#$y
r=: ks cf"_ 3 y
n=: r
NB. first forward pass. We need to build bias tensor.
if. bias -: '' do.
  bias=: <:+: ? (  1{ $ n) $ 0
  solver=: (<filter) setSolver tolower solverType
  e__solver=: alpha
end.
r=: r +"3 _  bias
r
)

NB. Backward pass through the layer. This function takes the next
NB. ( next in the forward direction) layer's output delta, updates
NB. the filter (weight) values, bias values,
NB. calculates the next delta, which it then returns.
NB. Arguments:
NB. 0: delta value from next layer.
NB. Returns:
NB.    the newly calculated delta value.
backward=: 3 : 0"_
ntd=: td=: y


NB. first backprop the activation

NB. Propagate the error backwards.
NB. For each weight:
NB. dError/dWeight = Sum dError/dOut * dOut/dWeight
NB. calculate each multiplicand separately.
NB. (1) - calculate dError/dOut
NB.
NB. For the transpose convolution, we need the
NB. padding, zero-insertion, stride, and kernel size
NB. see: https://arxiv.org/pdf/1603.07285.pdf (p. 23)
fp=. 0                        NB. assume forward padding is zero
fs=. 0{,ks                    NB. forward stride
fk=. 4{,ks                    NB. forward kernel size
zi=. fs - 1                   NB. zero insertion
bk=. fk                       NB. kernel size is same as forward
bz=. 1                        NB. backwards kernel stride
bp=. fk - fp + 1              NB. backwards padding
kernel=: 2 3 $ bz, bz, bz, (1{$td), bk, bk
NB. convolve prior tensor deltas with the forward filter
NB. First, transform td to the appropriate shape, padding.
ttd=: bp padAll"2 zi insertZeros td
dOut=: kernel bcf"_ 3 ttd NB. delta to be returned to previous layer.


NB. (2) - calculate dOut/dWeight
NB.
NB. We must expand the tensor of deltas by (stride-1) where stride is
NB. the stride number for the associated forward convolution.
stride=. 0{,ks NB. first index is the stride.
exdeltas=: (<:stride) insertZeros ntd NB. expanded next layer deltas.
NB. Now we can convolve the prior outputs with
NB. the exdeltas, where kernel size is the
NB. same as the forward convolution.

dW=: |:"3|:"4 (+/ % #) (exdeltas) deconv"3 2 i
dW=: (clampLow, clampHigh) clampV"1 0 dW
NB.dBias=. ((1&,@:$)$ ,) (+/ % #) ntd
filter=: >(<filter) calcGrad__solver <dW
bias=: bias - alpha * (+/ % #)+/"1+/"2 ntd
NB. finally return delta
dOut
)


deconv=: 4 : 0
kw=. 1{,$x NB. kernel width, and height.
kernel=: 2 2 $ 1, 1 ,kw,kw
kernel x&((+/@:,@:*)"2 _) ;._3 y
)

onBeginFit=: 3 : 0
''
)

onBeginPredict=: 3 : 0
''
)

getWeights=: 3 : 0
,>filter
)

NB. Inserts zeros between successive items of the
NB. array.
NB. x: number of zeros to insert between items
NB. y: array to insert into
insertZeros=: 4 : 0 "0 2
if. (x = 0) +. 1 = 1{$y do.y
else.
  zs=. x # 0	NB. the number of zeros
  ins=. [ , zs&,@:]
  ins/"1&.|: ins/"1 y
end.
)

NB. example:
NB. > zeros =: 4 # 0
NB. > b padLR zeros
NB. > 	0 0 0 0 3 3 0 0 0 0
NB. > 	0 0 0 0 3 3 0 0 0 0
padLR=: ( ,"1 ([,~"1 ]) ])

NB. example:
NB. > zeros =: 2 1 $ 0
NB. > b padTB zeros
NB. >	0 0
NB. >	0 0
NB. >	3 3
NB. >	3 3
NB. >	0 0
NB. >	0 0
padTB=: , ([ ,~ ]) ]

NB. Pads the tensor y with zeros along the right
NB. column, and bottom row.
NB. Example, tensor T has shape 10 5 5,
NB. padRB T will have shape 10 6 6, with zeros
NB. padded on right and bottom.
padRB=: 3 : 0
(|:"2 (|:"2 y), "(1) 0 ) ,"(1) 0
)

padTL=: 3 : 0
(0 ,"(1) |:"2 (0 ,"(1) |:"2 y) )
)

NB. example 4 padAll b
NB. gives a 4 padded matrix with center b
NB. y is a 2-d matrix, x is a positive integer.
NB.
NB. Example
NB. > b=: 2 2 $ 1 2 3 4
NB. > 2 padAll b
NB. >
NB. > 0 0 0 0 0 0
NB. > 0 0 0 0 0 0
NB. > 0 0 1 2 0 0
NB. > 0 0 3 4 0 0
NB. > 0 0 0 0 0 0
NB. > 0 0 0 0 0 0
padAll=: 4 : 0"0 2
zs=. x
(y padLR zs # 0) padTB (zs,1) $ 0
)

NB. Checks whether the given convolution fits
NB. exactly on the input matrix. ie. no padding is
NB. required and no cells of the input are leftover.
NB. Assumed padding is zero.
NB. see: https://arxiv.org/pdf/1603.07285.pdf (section 2.3)
NB. 	x: kernel shape
NB.	y: input shape
isConvExact=: 4 : 0
i=. y
s=. 0{ x
k=. 1{ x
0 = +/ s | i - k
)


destroy=: 3 : 0
try.
  destroy__solver ''
catch.
  smoutput 'Error destroying Conv2D gradient optimization solver.'
end. 
codestroy ''
)
