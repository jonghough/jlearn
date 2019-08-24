Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

cocurrent 'NN'

NB. Pooling layer for Conv2D layers. The assumption is that the previous layer
NB. will hold a 4D tensor (i.e. this layer must eb part of a conv-net. 
coclass 'PoolLayer'
coinsert 'NNLayer'

conv=: ;._3
convFunc=: +/@:,@:*
kernelFunc=: ((>./)@:,)

NB. Creates an instance of 'PoolLayer' for use after
NB. Convolution layers, used for downsampling datasizes, by
NB. selecting the largest datapoints inside poolSize grids of
NB. the dataset. The PoolLayer itself does not contribute to
NB. gradient in the output error, so the back propagation call
NB. simply depools the
NB. Parameters:
NB. 0: poolSize, the width (and height) of the pooling grids
create=: 3 : 0
if. a: -: y do.
  ''
else.
  poolSize=: y
  type=: 'PoolLayer'
end.
)

preRun=: 3 : 0
try.
  forward y
catch.
  smoutput 'Error in pre-run of PoolLayer.'
  smoutput 'Shape of input ',":y
  smoutput 'Size of pool is ',":poolSize
  throw.
end.
)

forward=: 3 : 0
i=: y
t=: (poolSize&pool)"2 i
)

backward=: 3 : 0
td=: y
V=: i
Z=: t
U=: poolSize depoolExpand Z
UV=: U=V
dpe=: poolSize depoolExpand td
UV * dpe NB. Previous layer's td
)


NB. max pool
pool=: 4 : 0
poolKernel=. 2 2 $ ,x
pooled=: poolKernel kernelFunc ;.3 y
pooled
)


NB. Reverses the pooling action, by depooling each
NB. item of the tensor, increasing tensor size, and
NB. replicating each value in the newly created items.
NB. example
NB.
NB. Tensor A is
NB. 0.7  0.8
NB. 0.23 0.3
NB.
NB. This will be depoolExpanded to
NB.
NB. 0.7  0.7  0.8  0.8
NB. 0.7  0.7  0.8  0.8
NB. 0.23 0.23 0.3  0.3
NB. 0.23 0.23 0.3  0.3
NB.
NB. using
NB. > 1 depoolExpand A
NB.
depoolExpand=: 4 : 0 "0 _
if. (x = 0) do.y
else.
  replicate=: x&#
  shape=: $ i
  reform=. ,/"2 replicate"0 y
  if. ({: shape) ~: {: $ reform do. reform=. }:"1 reform end.
  reform=. |:"2 ,/"2 replicate"0 |:"2 reform
  if. (2{ shape) ~: 2{ $ reform do. reform=. }:"2 reform end.
  reform
end.
)


destroy=: codestroy
