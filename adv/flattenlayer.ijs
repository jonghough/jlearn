Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


cocurrent 'NN'

NB. FlattenLayer is used after a Conv2DLayer to flatten the
NB. 3-dimensional output into a 2-dimensional tensor. The
NB. leading dimension of the input tensor is expected to be
NB. of length 1.
coclass 'FlattenLayer'
coinsert 'NNLayer'

NB. Creates an instance of FlattenLayer. In the  NN pipeline
NB. this should be placed after a Conv2DLayer or PoolLayer.
NB. It should be followed by a Fully connected layer. The purpose
NB. of the Flatten Layer is to reduce the dangling dimension
NB. of the output of the conv2d / pool layer(s).
NB. Parameters:
NB.    NO PARAMS.
create=: 3 : 0
type=: 'FlattenLayer'
)

preRun=: 3 : 0
try.
  forward y
catch.
  smoutput 'Error in pre-run of FlattenLayer.'
  smoutput 'Shape of input was ',": $ y
  throw.
end.
)

forward=: 3 : 0 
shape=: $y
,/"2,/"3 y
)

backward=: 3 : 0
shape $,y
)

destroy=: codestroy
