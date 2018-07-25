NB. Restricted Boltzmann Machine Implementation


NB. Restricted Boltzmann Machines can be used for pattern recognition,
NB. similar to Hopfield Networks (see hopfield.ijs) and for
NB. classification problems. The RBM network is generated with two
NB. layers - the visible layer, and the hidden layer.
NB. The Energy Function of an RBM is given by:
NB.    E(v,h) = -b'.v - c'.h - v'.W.h

Note 'References' 
[1] A Practical Guide to Training Restricted Boltzmann Machines, G. Hinton
https://www.cs.toronto.edu/~hinton/absps/guideTR.pdf

[2] Deep Learning, Ian Goodfellow, Yoshua Bengio, Aaron Courville
link: http://www.deeplearningbook.org/

)

require jpath '~Projects/jlearn/utils/utils.ijs'
require jpath '~Projects/jlearn/linear/logisticregression.ijs'
coclass 'BoltzmannMachine'

 
dot=: +/ . *
make2d=: ]`,:@.(1&=@:#@:$)  
create=: destroy=: codestroy


coclass 'RBM'
coinsert 'BoltzmannMachine'



NB. Instantiates the Restricted Boltzmann Machine implementation.
NB. Hidden units are assumed to be binary units (0 or 1)
NB. Params
NB. 0: visible node size
NB. 1: hidden node size
NB. 2: learning rate
NB. 3: batch size
NB. 4: Maximum number of iterations for fitting training data.
create=: 3 : 0
'vs hs lr bs maxIter'=: y
NB. Intialize weights from Normal N(0,0.1) distribution.
weights=: (vs # hs)  bmt_jLearnUtil_"0 _ [ 0 0.1
biasV=:  hs # 0
biasH=:  vs # 0
)

transform=: 3 : 0"1 
hp=. %>:^- (,biasV) + y dot weights
)

NB. Similar to a prediction, will reconstruct the best fitting 
NB. memory sample for the given data.
reconstruct=: 3 : 0
compVisible (?@:($&0)@:$ < ]) compHidden y
)

NB. Computes the hidden node values.
compHidden=: 3 : 0
%>:^- biasV +"_ 1 y dot weights
)

NB. Computes the visible node values.
compVisible=: 3 : 0
vn=. %>:^- biasH +"_ 1 |: weights dot |: y
vn=. ((?@:($&0)@:$) < ] ) vn
)


fit=: 3 : 0
assert. vs = 1{$ y
trainData=. y
nSamples=: {. $ trainData
biasV=: hs # 0
biasH=: vs # 0
nBatches=. >. nSamples % bs
hSamples=: (bs, hs) $ 0
iter=. 0
while. iter < maxIter do.
  iter=. iter+1
  index=. bs ?# trainData	 
  data=. index { trainData	 
  fitBatch data
end.

)

NB. Fits a single batch of samples using
NB. C_D algorithm.
NB. Parameters:
NB. y: Sample batch
NB. returns:
NB.    None
fitBatch2=: 3 : 0 
i=:  y

pha=: y dot weights
php=: %>:^- biasV +"_ 1 pha
phs=: ((?@:($&0)@:$) < ] ) php
pa=: (|: i) dot php

nva=: phs dot |: weights
nvp=: %>:^-  biasH +"_ 1 nva
nha=: nvp dot weights
nhp =: %>:^-  nha
na=:  (|: nvp) dot nhp
weights =: weights + lr * (pa - na) % bs


''
)

fitBatch=: 3 : 0
i=: y
hp=: compHidden i
vn=: compVisible hSamples
hn=: compHidden vn

upd=: (|: i) dot hp
NB. update value is model minus data
upd=: upd - |:(|: hn) dot vn
 

NB. update weights
weights=:   weights + lr * upd

NB. update biases
biasV=: biasV +"_ 1 lr * +/(hp - hn)
biasH=:   biasH +"_ 1 lr * +/(i - vn) 

hn=: ((?@:($&0)@:$) < ] ) hn
error=: *: i - vn
hSamples=: <. hn
)

NB. Calculates the free energy of a visible vector.
NB. See [1] Section 16.1
NB. 
calculateFreeEnergy=: 3 : 0"1
i=. make2d y
,(-(|:i) dot~ biasH) -^.+/ 1+^, (i dot weights) + biasV
)

gibbs=: 3 : 0
h=. ((?0)&<)"0 compHidden make2d y
v=. compVisible h
)

destroy=: codestroy


NB. Restricted Boltzmann Machine Classifier. Inherits from the
NB. RBM class.
coclass 'RBMClassifier'
coinsert 'RBM'

create=: 3 : 0
(create_RBM_ f.) }:y
classCount=:>{:y
NB.logReg=: (hs;classCount;500;'gd';'softmax';0.001;50; 'l2') conew 'LRC'
logReg=: (hs;classCount;5;'gd';'softmax';0.01;10; 'l2') conew 'LRC'

) 

fitClassify=: 4 : 0
fit y

Xp=. transform y
smoutput $ x
smoutput $ Xp
smoutput '-'
x fit__logReg Xp
''
)

predict=: 3 : 0"1
predict__logReg transform y
)


destroy=: codestroy


Note 'Example'
rbm=: (5 32 0.12 1 3500) conew 'RBM'
NB. 6 samples
   A=: 6 5 $ 0 1 0 1 1 1 1 0 1 0 1 1 0 0 1 1 1 0 0 1 1 0 1 0 1 1 1 1 0 0
 fit__rbm A
compVisible__rbm (?@:($&0)@:$ < ]) compHidden__rbm 1 5 $ 1 0 1 0 1



)
rbm=: (6 22 0.12 1 3500) conew 'RBM'

compVisible__rbm@:(?@:($&0)@:$ < ])@:compHidden__rbm@:(1 6&$@:,)"1 A

compVisible__rbm (?@:($&0)@:$ < ]) compHidden__rbm 1 6 $ 1 0 0 0 0 0


   rbm=: (64;100;0.01;25;5500;10) conew 'RBMClassifier' 
   Y fitClassify__rbm X 
+/  W-:"1 1 (=>./)"1 predict__rbm Z