Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

require jpath '~Projects/jlearn/adv/advnn.ijs'

NB. Activation layer.
coclass 'Activation'
coinsert'NNLayer'

NB. Instantiate Activation layer. 
NB. Parameters:
NB. 0: activation function to use:
NB.    Can be pne of:
NB.    'relu'
NB.    'tanh'
NB.    'logistic'
NB.    'identity'
NB.    'softmax'
NB.    If the activation layer is the final layer, meaning
NB.    no further network layers, then the activation function
NB.    must be 'softmax' or 'logistic' for classification problems,
NB.    or 'identity' for regression problems.
create=: 3 : 0
if. y -: a: do.
  ''
else.
  'activation'=: y
  setActivationFunctions activation
end.
isLast=:0
setIsLast=: 0
type=: 'Activation'
)

forward=: 3 : 0
i=: y
act i
)

backward=: 3 : 0
delta=.y
if. (isLast = 0 )*. setIsLast = 1 do.
  delta=. (dact i) * delta
elseif. setIsLast = 0 do.
    setIsLast=:1
  if. next -: '' do.
    isLast=: 1
  elseif. type__next -: 'BatchNorm' do.
    isLast=: 1
  end.
if. isLast = 0 do. 
  delta=. (dact i) * delta 
end.
end.
delta
)

destroy=: 3 : 0
codestroy ''
)