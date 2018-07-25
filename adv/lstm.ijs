Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


NB. Long Short Term Memory Cell implementation

Note 'Diagram'


             ^
             |
             |
            (x)<---------------------
             ^                       \
             |  ->------------>-      \
             | /                \      \
             |/                 /       |
     /--<---(+)<---------(x)<---        |
     |       ^            ^             |
     |       |            |             |
     |       |             \            |
     |       |              \           |
     |       |               \          |
     |      (x)<----          \         |
     |       ^      \          |        |
     |       |       \         |        |
     |       |        \        |        |
     |       |        |        |        |
     |     (sig)    (sig)    (sig)    (sig)
     |       ^        ^        ^        ^
     |       |        |        |        |
     |     INPUT    IGATE    FGATE    OGATE
     |     ^  ^     ^  ^     ^  ^     ^  ^
     |     |  |     |  |     |  |     |  |
     \-->--+--------+--------+----->--+  |
              |        |        |        |
              |        |        |        |

)

NB. Implementation of a 'Long Short Term Memory Cell'. Implementation
NB. based on the description in [1] Chapter 10. LSTMs are used with
NB. RNNs to give more responsive networks. LSTM takes as input
NB. the current time step's input value (x), and the previous
NB. time step's hidden value (h), which is essentially part of the
NB. LSTM's state, along with the state variable (s).
NB. The LSTM Cell has 3 gates:
NB. 1. input gate   (g)
NB. 2. forget gate  (f)
NB. 3. output gate  (q)
NB.
NB. Each gate has its own W, U tensors, where W is the hidden-to-hidden
NB. layer update tensor, and U is the input layer-to-hidden layer update
NB. tensor.
coclass 'LSTMLayer'
coinsert 'NNLayer'

initWeights=: 4 : 0 "0 1
x * +: 0.5-~ ? y $ 0 NB. TODO fix this
)

dot=: +/ . *

NB. Creates an instance of LSTMLayer. Used for applying neural
NB. networks to sequences. The LSTMLayer will take a sequence of vectors
NB. and returns an output vector for each vector, and passing the state
NB. to the next vector output calculation. Depending on whether 'isSequential'
NB. floag is true or false, the LSTMlayer either outputs a single output vector
NB. for the last input vector, or a sequence of output vectors (one for each input
NB. vector). The latter type is useful for 'stacking' LSTMLayers, where the output
NB. of the first layer becomes the input of the second layer. If 'isSequential' is
NB. set ot 0, then the output is useful for passing to a 'SimpleLayer', i.e. a
NB. fully connected layer, which will further transform the output vector.
NB. The LSTMLayer's hidden size gives the actual size of the layer. Large sizes
NB. become slower to train, but can handle more complex, and longer sequences.
NB.
NB. Parametrs:
NB. 0: act - the activation function of the output. Can be one of
NB.          tanh
NB.          logistic
NB.          identity
NB.          relu
NB. 1: drop - dropout flag. If 1, then dropout is implemented.
NB. 2: alpha - ...
NB. 3: solverType - type of solver to use for back propagation can be one of
NB.    adam
NB.    sgd
NB.    sgdm
NB. 4: batchSize - the batch size to use in training. Must match the batch
NB.    size of the other layers in the network.
NB. 5: inSize - the size of the LSTMLayer's U* matrices. That is, the input size.
NB. 6: hSize - the size of the LSTMLayer's W* matrices. That is, the hidden size
NB. 7: seq - the number of vectors in the input sequence. For example,
NB.    if the input is a sequence of characters 'a','b','c','d','e', then
NB.    after vector-encoding each character, the input becomes a sequence of
NB.    5 vectors. In this case, 'seq' should be 5.
NB. 8: isSequential - flag to determine whether the output of the LSTMLayer is
NB.    the output for each vector of the input sequence (i.e. another vector-sequence)
NB.    or only the output of the final vector in the input sequence.
NB.
NB. Example:
NB. > myLL = (0;0;0.1;'adam';20;15;256;;0) conew 'LSTMLayer'
NB. >
create=: 3 : 0
'activation drop alpha solverType bs inSize hSize seq isSequential'=: y
if. a: -: y do.
  ''
else.
  solverType=: tolower solverType
  assert. +/ (<solverType) -:"_ 0 'adam';'sgd';'sgdm'
  assert. bs > 0
  uSize=: (inSize), hSize
  wSize=: (hSize), hSize
  setActivationFunctions activation
  sigmoid=: tanh_NN_
  dsigmoid=: dtanh_NN_
  hiddenSize=: {: uSize
  'U Uf Ug Uq W Wf Wg Wq'=:  ,/>(<activation) createRandomWeightsNormal&.>"_ 0 (4 $ <uSize), 4 $ <wSize 
diffs=: <"0[8$0
NB. all states array initially empty
  as=: '' NB. all states
  sp=: (bs, hiddenSize) $ 0 NB. previous state parameter
  hp=: (bs, hiddenSize) $ 0 NB. previous hidden parameter
  dXs=: '' NB. cache of the input 'X' grad values for one training run.
   
NB. set the solver 
  solvers=: (U;Uf;Ug;Uq;W;Wf;Wg;Wq) setSolver solverType
  e__solvers=: alpha
NB. states
  for_i. i.seq do.
    state=. (bs, hiddenSize) conew 'LSTMState'
    as=: as,state
  end.
  stateCtr=: 0
  type=: 'LSTMLayer'
end.
)

NB. Clamps the argument in range [-1,1].
clamp=: 3 :0 "0
]`*@.(_1&>)`1:@.(1&<) y
)


NB. Clears memory, all state instances are cleared and
NB. diffs,hp,sp,h variables are reset.
clear=: 4 : 0
for_j. i. # as do.
  ls=. j{as
  refresh__ls ''
end.

stateCtr=: 0
diffs=: <"0[8$0
sp=: (x, hiddenSize) $ 0
hp=: (x, hiddenSize) $ 0
h=: (x, hiddenSize) $ 0
)


NB. This needs to be called before each step of
NB. training.
onBeginFit=: 3 : 0
bs clear ''
)

NB. Needs to be called before each predict run.
onBeginPredict=: 3 : 0
1 clear ''
)

preRun=: 3 : 0
try.
  forward y
catch.
 smoutput 'Error in pre-run through LSTM layer.'
 smoutput 'Shape of input was ',": y
 smoutput 'Shape of hidden matrices is ',": $U
 clear ''
 throw.
end.
clear ''
smoutput 'LSTM layer ok'
)

NB. Forward pass through LSTM cell. The operation
NB. depends on whether the LSTM is sequential or not.
NB. In the case of a sequential LSTM, the verb will
NB. return a sequential vector of the shape specified
NB. in the constructor. Otherwise it will return a
NB. tensor of shape batchsize x hiddenSize.
NB. Parameters:
NB. y: input data.
forward=: 3 : 0
ts=: ''  NB. output(s)
dXs=: ''
for_i. i.seq do.
  n=: forwardpass i{"2 y
  t=: act n

  ts=: ts,<t
end.
if. isSequential do.
  tts=: |:"2|:"3|:"2 >ts
  tts    
else. 
  t
end.
)

forwardpass=: 3 : 0
state=. stateCtr{as
stateCtr=: >: stateCtr
NB. set the previous state and hidden params.
ps__state=: sp
ph__state=: hp
in__state=: xi
yb=. y,"1[1
hpb=. hp,"1[1 
NB. forget gate
f=. sigmoid (yb dot Uf) + hpb dot Wf NB. (10.40)
NB. external input gate
g=. tanh (yb dot Ug) + hpb dot Wg NB. (10.42)
NB. output gate
q=. sigmoid (yb dot Uq) + hpb dot Wq NB. (10.44)
NB. input gate
i=. sigmoid (yb dot U) + hpb dot W
NB. internal state
s=: (f*sp) + g * i  NB. (10.41)
h=: (tanh s) * q NB. (10.43)
cs__state=: s NB. set current state
ch__state=: h NB. set current hidden
i__state=: i
f__state=: f
g__state=: g
q__state=: q
xi__state=: y
NB.as=: as,state NB. append state
sp=: s NB. next level's previous state parameter
hp=: h NB. next level's previous hidden parameter 
h
)

NB. Backwards pass through the LSTM layer.
NB. The backwards pass operation depends on whether
NB. the LSTM instance is 'sequential' or not.
backward=: 3 : 0
if. isSequential do.
delta=: (* dact)&.> y
else. 
delta=: y * dact y
end.
sg=. ''
ndelta=. 0
allDeltas=: ''
NB.
NB.  output1       output2           output3
NB.    |             |                 |
NB.    |             |                 |
NB.    |             |                 |
NB.  state1--------state2----....----state3
NB.    |             |                 |
NB.    .             .                 .
NB.    .             .                 .
NB. In above diagram, state3 (final lstm state) is updated using,
NB. gradient from output (delta), and the state gradient (sg).
NB. Previous states are updated similarly, and the state gradient
NB. is changed with every pass through each state.
NB. In the case of a non-sequential LSTM layer, the output delta
NB. is only required from the final output (output3 in the diagram).
NB. 
if. isSequential do.
NB. number of deltas must equal number of states in sequence.
  for_i. |.i.seq do.
    'ndelta sg'=. backwardpass (ndelta + >i{delta);sg;i
  end.
elseif. 1 do.
NB. not sequential, only need final output delta
  ndelta=. delta
  for_i. |.i.seq do.
    'ndelta sg'=. backwardpass (ndelta);sg;i
  end.
end.
updateWeights ''
dXs
)



NB. Backpropagation part. Here the gradient parts
NB. from previous layer and the state are used.
backwardpass=: 3 : 0
'DH DS idx'=: y
state=. idx{as
xi=: xi__state
sp=: ps__state
if. -.DS-: '' do.
  ds=. DS + (dtanh cs__state) * q__state * DH
else.
  ds=. (dtanh cs__state) * q__state * DH
end.
ds=. clamp ds

dq=. (tanh cs__state) * DH
di=. g__state * ds
dg=. i__state * ds
df=. sp * ds

derivI=. clamp di * dsigmoid i__state
derivF=. clamp df * dsigmoid f__state
derivG=. clamp dg * dtanh g__state
derivQ=. clamp dq * dsigmoid q__state

ddWi=. derivI dot |: }: W
ddWf=. derivF dot |: }: Wf
ddWg=. derivG dot |: }: Wg
ddWq=. derivQ dot |: }: Wq

NB. ===== matrix deltas =======
chb=. |: ch__state,"1[ 1 NB. bias added
xib=. |: xi,"1[ 1 NB. bias added
dWi=. bs %~ chb dot derivI
dWf=. bs %~ chb dot derivF
dWg=. bs %~ chb dot derivG
dWq=. bs %~ chb dot derivQ
dUi=. bs %~ xib dot derivI
dUf=. bs %~ xib dot derivF
dUg=. bs %~ xib dot derivG
dUq=. bs %~ xib dot derivQ
diffs=: diffs +&.> dUi;dUf;dUg;dUq;dWi;dWf;dWg;dWq
NB. =========================================================
NB. ========= X grads ===========
dxi=. derivI dot |: }: U
dxf=. derivF dot |: }: Uf
dxg=. derivG dot |: }: Ug
dxq=. derivQ dot |: }: Uq
dX=. dxi+dxf+dxg+dxq
dXs=: dXs,<dX
NB. ======== time grads =========
derivH=. ddWi+ddWf+ddWg+ddWq
NB. ======== state grads ========
derivS=. ds * f__state
NB. =========================================================
derivH;derivS
)

NB. Updates the LSTM weights. There are 8 weight matrices that 
NB. are updated, and the update operation uses the gradient
NB. optimization class definied in the LSTM constructor.
updateWeights=: 3 : 0
'U Uf Ug Uq W Wf Wg Wq'=: (U;Uf;Ug;Uq;W;Wf;Wg;Wq) calcGrad__solvers diffs
)


destroy=: 3 : 0
if. 0< #as do.
  try.
    for_j. i.#as do.
      state=. i{as
      destroy__state ''
    end.
  catch.
    smoutput 'Error destroying LSTM.'
  end.
end.
try.
  destroy__solver ''
catch.
  smoutput 'Error destroying LSTM solver.'
end.
codestroy ''
)

NB. Internal state of the lstm at a given step.
NB. LSTMLayer contains an array of 'LSTMState'
NB. instances, wehre each instance represents the state
NB. at the corresponding timestep.
coclass 'LSTMState'

create=: 3 : 0
if. a: -: y do.
  ''
else.
  shape=: y
  cs=: shape $ 0 NB. current s
  ps=: shape $ 0 NB. previous s
  ch=: shape $ 0 NB. current h
  ph=: shape $ 0 NB. previous h
  xi=: ''
  shape=: $ cs
  'i f g q'=: 0 0 0 0
end.
)

refresh=: 3 : 0
cs=: shape $ 0 NB. current s
ps=: shape $ 0 NB. previous s
ch=: shape $ 0 NB. current h
ph=: shape $ 0 NB. previous h
xi=: ''
shape=: $ cs
'i f g q'=: 0 0 0 0
)

destroy=: codestroy
