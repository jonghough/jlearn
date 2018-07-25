Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[0] Deep Learning, Bengio Y., Courville, A., Chapter 8.
see: http://www.deeplearningbook.org/contents/optimization.html

[1] An overview of gradient descent optimization algorithms, Ruder, S.
see: arXiv:1609.04747

)


cocurrent 'jMlpOpt'

 
NB. Multilayer Perceptron Backprop Solvers. A collection
NB. of classes implementing various optimizations for the
NB. learning rate in MLP backpropagation networks.
coclass 'MLPSolver' 
e=: 0.01
create=: destroy=: codestroy

calcGrad=: 4 : 0
0
)

destroy=: codestroy



NB. ADApative Moments solver.
NB. see: Deep Learning, Benjio; Godfellow; Courville
NB. 8.5.3 page 301.
coclass 'AdamSolver'
coinsert 'MLPSolver' 
create=: 3 : 0
rho1=: 0.9 NB.y # 0.9
rho2=: 0.999 NB.y # 0.999
d=: 1e_2
e=: 0.02
t=: 0 NB. y # 0
s=: (($&0)@:$) &.> y NB. y # 0
r=: (($&0)@:$) &.> y NB. y # 0
)

reset=: 3 : 0
rho1=: 0.9 NB.y # 0.9
rho2=: 0.999 NB.y # 0.999
d=: 1e_8
e=: 0.02
t=: 0 NB. y # 0
s=: (($&0)@:$) &.> s NB. y # 0
r=: (($&0)@:$) &.> r NB. y # 0
)

calcGrad=: 4 : 0

t=: >:t
NB.===========Begin==========
rho1m=. 1 - rho1
rho2m=. 1 - rho2
a1=. (rho1&*)&.> s
a2=. (rho2&*)&.> r
s=: a1 ([+(rho1m&*@:]))&.> y
r=: a2 ([+(rho2m&*@:*:@:]))&.> y
rr1=. 1 -rho1^t
rr2=. 1 -rho2^t
shat=: (%&rr1)&.> s
rhat=: (%&rr2)&.> r
gr=. shat (e&*@:([ % (d&+@:%:@:])))&.> rhat
x -&.> gr
)

destroy=: codestroy



NB. Stochastic Gradient Descent Solver
NB. Simplest implementation, no momentum.
coclass 'SGDSolver'
coinsert 'MLPSolver' 
create=: 3 : 0
e=: y
)

calcGrad=: 4 : 0
x (([-(e&*@:]))&.>) y
)

reset=: 3 : 0
r=. 0
)

destroy=: codestroy


NB. SGD solver with momentum.
coclass 'SGDMSolver'
coinsert 'SGDSolver' 
vupdate=: ((2&*@:[) - (3&*@:]))&.>

create=: 3 : 0
'e a'=: y  NB. learning rate;momentum
r=: ''     NB. initial velocity matrix (boxed matrices, one matrix for each layer of ANN)
)

reset=: 3 : 0
r=: ''
)

calcGrad=: 4 : 0
if. r -: '' do. r=: ($&0@:$)&.>y end.
r=: r ((a&*@:[) - (e&*@:]))&.> y
x +&.> r
)

destroy=: codestroy

NB. AdaGrad implementation.
coclass 'AdaGradSolver'
coinsert 'SGDSolver' 
d=: 1e_7
create=: 3 : 0
r=: (($&0)@:$) &.> y
e=: 0.01
)

reset=: 3 : 0
r=: 0
)

calcGrad=: 4 : 0
grad=. y
r=: r ([+(*:@:]))&.> grad
x -&.> grad *&.> e&%@:(d&+)&.>r
)

destroy=: codestroy

NB. RMSProp implementation

coclass 'RMSPropSolver'
coinsert 'MLPSolver'

create=: 3 : 0
d=: 1e_6
rho=: 0.99
e=: 0.01
r=: (($&0)@:$) &.> y
)


calcGrad=: 4 : 0
grad=. y
rm=. 1-rho
r=: r (rho&*@:[+(rm&*@:*:@:]))&.> grad
x -&.> grad *&.> e&%@:(d&+)&.>r
)

destroy=: codestroy



