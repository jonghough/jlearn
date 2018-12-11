Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Implementation of a Dropout Layer. Dropout Layer can 
NB. be placed after other layers to allow backpropagation
NB. updates to only a random percentage fo the number of
NB. nodes in the previous layer, as a form of regularization.

coclass 'Dropout'
coinsert 'NNLayer'

create=: 3 : 0
prob=: y
'Invalid probability set.' assert (prob >: 0) *. prob<:1
type=: 'Dropout'
)


preRun=: 3 : 0
'Dropout layer has invalid probability set.' assert (prob >: 0) *. prob<:1
try.
  forward y
catch.
  smoutput 'Error in prerun of Dropout layer.'
end.
)

onBeginFit=: 3 : 0
''
)

onBeginPredict=: 3 : 0
''
)

forward=: 3 : 'forwardPassFit y'

forwardPassFit=: 3 : 0
shape=: $ y
drop=: ( <.@:((1-prob)&*) ? ])#,y
dropnet=: (shape) $ 0 drop}, (#,y) # 1
t=:  dropnet * y
)

forwardPassPredict=: 3 : 0
t=: prob * y
)

backward=: 3 : 0
dt=.  dropnet * y
)

onBeginFit=: 3 : 0
forward=: 3 : 'forwardPassFit y'
''
)

NB. Needs to be called before each predict run.
onBeginPredict=: 3 : 0
forward=: 3 : 'forwardPassPredict y'
''
)

destroy=: codestroy
