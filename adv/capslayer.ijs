Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)
 
NB. Capsule Layer
coclass 'CapsLayer'
coinsert 'NNLayer'v


create=: 3 : 0
'shape ks activation alpha'=: y
assert. 4 = # shape NB. wxhxdinxdout
assert. 2 3 -: $ ks
assert. alpha > 0 
filter=: 1 %~ +: 0.5-~ ? shape $ 0 NB. TODO create random
a=. setActivationFunctions activation
act=: ({.a)`:6
dact=: ({:a)`:6
bias=: ''
)