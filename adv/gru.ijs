NB. GRU implementation.




coclass 'GRULayer'
coinsert 'NN'


create=: 3 : 0
'act drop alpha solverType bs uSize wSize seq isSequential'=: y
solverType=: tolower solverType
assert. +/ (<solverType) -:"_ 0 'adam';'sgd';'sgdm'
assert. bs > 0

activation=: tanh
dact=: dtanh
sigmoid=: tanh
dsigmoid=: dtanh
dot=: +/ . *
hiddenSize=: {: uSize
'Uz Ur Ug Wz Wr Wg'=: (<0.8) (initWeights&.>) (4 $ <uSize), 4 $ <wSize
diffs=: <"0[6$0
NB. all states array initially empty
as=: '' NB. all states
sp=: (bs, hiddenSize) $ 0 NB. previous state parameter
hp=: (bs, hiddenSize) $ 0 NB. previous hidden parameter
dXs=: '' NB. cache of the input 'X' grad values for one training run.
lr=: 0.1
NB. setSolver solverType
solvers=: 0.01 conew 'SGDSolver'
hs=: ''
)

forward=: 3 : 0
ts=: ''
dXs=: ''
for_i. i.seq do.
  n=: forwardpass i{"2 y
  t=: activation n
  ts=: ts,<t
end.

if. isSequential do. 
tts=:|:"2|:"3|:"2 >ts
tts
else.
t
end.
)

forwardpass=: 3 : 0
NB. append bias
hp=. hs
yb=. y,"1[1
hpb=. hp,"1[1
z=. sigmoid (yb dot Uz) + hpb dot Wz  
r=. sigmoid (yb dot Ur) + hpb dot Wr  
g=. tanh (yb dot Ug) + (r * hpb) dot Wg 
h=: (1 - z) * tanh (hpbb dot Ug) + g * z

)

destroy=: codestroy 


coclass 'GRUState'

create=: 3 : 0
shape=: y 
ch=: shape $ 0 NB. current h
ph=: shape $ 0 NB. previous h
xi=: ''
'i f g q'=: 0 0 0 0
)