Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Implementation of unconstrained BFGS and Limited Memory BFGS function
NB. minimization algorithms.
NB. This implementation is not particularly optimized, other possible implementation
NB. is at: https://gist.github.com/jxy/9db97e44708d0946c3da2d7e82fefcd0

Note 'References'
[1] Numerical optimization, Nocedal & Wright
)

require jpath '~Projects/jlearn/optimize/linesearch.ijs'

cocurrent 'jLearnOpt'

minBFGSX=: 3 : 0
'funcWrapper x0 maxIter tol beta'=: y
func=. 3 : 'func__funcWrapper y'
fprime=. 3 : 'fprime__funcWrapper y'
minBFGS ((func f.)`'');((fprime f.) `'');x0;maxIter;tol;beta
)

minLBFGSX=: 3 : 0
'funcWrapper x0 maxIter tol beta'=: y
func=. 3 : 'func__funcWrapper y'
fprime=. 3 : 'fprime__funcWrapper y' 
minLBFGS ((func f.)`'');((fprime f.) `'');x0;maxIter;tol
)


NB. Runs the BFGS algorithm to minimize a givent function, f,
NB. given it's gradient fprime. This is not the limited memory
NB. version of BFGS algorithm. Given an n-dimensional real function f,
NB.and it's gradient gf, and an initial n-dimensional point x0, this
NB. verb will find f's minimum using BFGS.
NB. Arguments:
NB. 0: gerund of the function to optimize
NB. 1: gerund of the gradient of argument 0
NB. 2: Initial point
NB. 3: maximum number of iterations
NB. 4: tolerance for the accuracy of the solution.
NB. 5: Scale factor for initial Hessian.
NB.
NB. Example:
NB. >  NB. function and gradient
NB. >  g=:+/@:(^&3) - +/@:(*: + 20&*)
NB. >  gprime=:3&*@:*: - 20&+@:+:
NB. >  minBFGS_BFGS_ (g f.`'');(gprime f.`'');(6.937 22.937 8.937);1000;0.00001;0.01
NB. 
minBFGS=: 3 : 0"1
'fg fpg x0 maxIter tol beta'=: y
dot=: +/ .*
make2d=: (1&,@:$ $ ])
assert. maxIter > 0
func=. fg `:6
fprime=. fpg `:6
k=. 0
I=. (=@i.) # x0
xk=. ,x0
pk=. ''
gfk=. fprime xk 

Hk=. I *beta
while. (k < maxIter) *. tol < +/&.:*:gfk do.
  pk=. ,-Hk dot |: make2d fprime xk
  try.
    ak=. lineSearch_jLearnOpt_ fg;fpg;xk;pk;0;0.1e_4;0.9;5;300
  catch.
    smoutput 'Error attempting line search. The input values to the function may be too extreme.'
    smoutput 'Function input value (xk): ',":xk
    smoutput 'Search direction value (pk): ',":pk
    smoutput 'A possible solution is to reduce the size of the initial inverse hessian scale, beta.'
    smoutput 'Beta is currently set to ',(":beta), ', which may be too large/small.'
    throw.
 end.
  xkp1=. xk+ak*pk
  sk=. make2d xkp1 -xk
  gfk=. fprime xkp1
  yk=. make2d gfk - fprime xk
  rhok=. ''$,% yk dot |: sk
  Hk=. (rhok* (|:sk) dot sk)+ ( I - rhok*(|:sk) dot yk) dot Hk dot (I - rhok*(|:yk) dot sk)
  xk=. xkp1
  k=. k+1
end.
xk
)


NB. Runs the BFGS algorithm to minimize a givent function, f,
NB. given it's gradient fprime. This is not the limited memory
NB. version of BFGS algorithm. Given an n-dimensional real function f,
NB.and it's gradient gf, and an initial n-dimensional point x0, this
NB. verb will find f's minimum using BFGS.
NB. Arguments:
NB. 0: gerund of the function to optimize
NB. 1: gerund of the gradient of argument 0
NB. 2: Initial point
NB. 3: maximum number of iterations
NB. 4: tolerance for the accuracy of the solution.
NB.
NB. Example:
NB. >  NB. function and gradient
NB. >  g=:+/@:(^&3) - +/@:(*: + 20&*)
NB. >  gprime=:3&*@:*: - 20&+@:+:
NB. >  minLBFGS_BFGS_ (g f.`'');(gprime f.`'');(6.937 22.937 8.937);1000;0.00001
NB. 
minLBFGS=: 3 : 0"1
'fg fpg x0 maxIter tol'=: y
dot=: +/ .*
make2d=: (1&,@:$ $ ])
assert. maxIter > 0
func=. fg `:6
 
fprime=. fpg `:6
k=. 0
xk=. x0
gfk=. fprime xk
I=. (=@i.) # x0
NB. initialize Hk(k=0).
Hk0=. 0.001 $~ #x0 
m=. 20
ctr=. 0
aks=. rhoks=. m$0 NB. array of a_k's and rho_k's
yks=. sks=. 0$~ m,#xk NB. array of y_k's, s_k's
while. (ctr < maxIter) *. (tol < +/&.:*: gfk) do.
  
  
NB.===================== 2-loop step ========================
g=. gfk 
  bnd=. k<.m
  for_j.|. k|.i.bnd do.
    
    aks=. (+/ (j{rhoks) * (j{sks) * g) j}aks
    g=. g - (j{aks) * (j{yks)
  end.
  r=. Hk0 * g
  for_j. k|.i.bnd do.
    b=. +/ (j{rhoks) * (j{yks) * r
    r=. r + (,j{sks)*((j{aks) - b)
  end.
NB.==========================================================

  pk=. -r 
try. 
    ak=. lineSearch_jLearnOpt_ fg;fpg;(xk);(pk);0;0.00001;0.9;100;10
 catch.
    smoutput 'Error attempting line search. The input values to the function may be too extreme.'
    smoutput 'Function input value (xk): ',":xk
    smoutput 'Search direction value (pk): ',":pk
    smoutput 'A possible solution is to reduce the size of the initial inverse hessian scale, beta.'
    smoutput 'Beta is currently set to ',(":beta), ', which may be too large/small.'
    throw.
end.
  aks=. ak k}aks
  xkp1=. xk+ak*pk
  gfk=. fprime xkp1
  yk=. gfk - fprime xk
  if. k > m do. sks=. (0 $~ #xk) (k-m)} sks end.
  sks=. (xkp1 -xk) k}sks
  rhoks=. (''$,% yk dot |: (k{sks)) k}rhoks
  yks=. yk k}yks
  xk=. xkp1
  k=. (m) | k+1
  ctr=. ctr+1
end.
xk
)


