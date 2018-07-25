Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)
NB. Conjugate Gradient method


Note 'References'
[1] Scipy Implementation
https://github.com/scipy/scipy/blob/master/scipy/optimize/optimize.py

[2] Numerical Optimization, Nocedal & Wright
)


require jpath '~Projects/jlearn/optimize/linesearch.ijs'


cocurrent 'jLearnOpt'

dot=: +/ . *


minCGX=: 3 : 0
'funcWrapper x0 maxIter tol beta'=: y
func=. 3 : ' func__funcWrapper y'
fprime=. 3 : 'fprime__funcWrapper y'
minCG ((func f.)`'');((fprime f.) `'');x0;maxIter;tol;beta
)



NB. Finds the minimum of the given function, partial derivative pair,
NB. given the start point, max number of iterations, tolerance, and
NB. optimization method.
NB. example call:
NB. Params: minFRCG_jLearnOpt_ (f f. `'');(fp f.`'');(0.1 0.1 0.1); 1000; 0.001;'fr'
NB.
NB. 0: gerund of the function to minimize
NB. 1: gerund of the partial derivative of the function
NB. 2: initial start point to use
NB. 3: max number of iterations
NB. 4: tolerance
NB. 5: optimization method, either ...
NB. returns: minimization point. That is, the point at a local minimum
NB. of the given function.
minCG=: 3 : 0
'fg fpg x0 maxIter tol beta'=: y
func=. fg `:6
fprime=. fpg `:6

xk=. x0
gfk=. -fprime x0
if. maxIter < 1 do. maxIter=. 1 end.
if. tol < 1e_6 do. tol=. 1e_6 end.

beta=. tolower beta
'Value must either be ''pr'' or ''fr''' assert (<beta) e. 'pr';'fr'

p0=. gfk
pk=. p0
k=. 0
while. tol < +/&.:*:gfk do. 
  k=. k+1
  if.-. k < maxIter do. 
smoutput 'Failed search after ',(": maxIter), ' iterations.'  
    throw. 
  end.
  try. 
    ak=. lineSearch_jLearnOpt_ fg;fpg;xk;pk;0;1e_4;0.9;50;100
  catcht.
    smoutput 'Error attempting line search.'
    throw.
  end.
  xkp1=. xk + ak * pk
  gfkp1=. fprime xkp1
  gfk=. fprime xk
  
  if. beta -: 'fr' do.
    bkp1=. (+/ *: gfkp1) % (+/ *: gfk) NB. fletcher-reeves
  elseif. beta -: 'pr' do.
    bkp1=. ((+/ *: gfkp1) * (gfkp1 - gfk)) % (+/ *: gfk) NB. polak-ribiere
  end.
  pk=. (-gfkp1) + bkp1 * pk
  xk=. xkp1
  
end.
xk
)
