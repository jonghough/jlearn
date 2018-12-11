Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)
NB. Factor Analysis.

Note 'References'
[1] Scikit-Learn Factor Analysis implementation
link: https://github.com/scikit-learn/scikit-learn
[2] Statistical Pattern Recognition, Andrew Webb, pp. 337 - 342
https://seat.massey.ac.nz/personal/s.r.marsland/Code/Ch6/factoranalysis.py
[3] The EM Algorithm for Mixtures of Factor Analyzers (1996), Ghahramani, Z., Hinton, G.
link: https://www.csie.ntu.edu.tw/~mhyang/course/u0030/papers/Mixture%20of%20Factor%20Analyzers.pdf
)

load 'math/lapack'
load 'math/lapack/gesvd'

NB. Factor Analysis. Reduces the dataset dimensionality to a
NB. smaller matrix which has linearly independent features
coclass 'FASolver'
EPSILON=: 0.000001
MAX_ITERATION=: 1e5
PI=: o. 1
dot=: +/ .*
columnmean=: +/ % #
NB. covGM generates a covariance matrix for the
NB. given data set.
covGM=: ((|:@:[dot])/~@:(-"1 1 columnmean) % (<:@:#))


create=: 3 : 0
reducedDims=: y
)

NB. Decompose matrix using SVD.
decomp=: 3 : 0
gesvd_jlapack_ y
)

fit=: 3 : 0
X=: y
A=: y
'samples comp'=: $y
W=: ? (comp, reducedDims) $ 0

llConst=: comp * ^. (2 * o. 1) + comp
m=. columnmean y
Xp=. X-"1 1 m
covar=: covGM Xp

psi=: (<0 1) |: covar
PSI=: (psi *"_ 1 (=@i.) # psi )
sqrtPsi=: EPSILON + %: psi
N=. # A

it=. 0
oldL=: __
while. MAX_ITERATION > it=. it+1 do.
  A=: PSI + W dot |: W
  LA=: ^. | (-/ .*) A
  A=: %. A
  BETA=: A dot~ |: W
  Ez=: BETA dot covar NB. Ez
  Ezz=: ((=@i.) reducedDims) - (BETA dot W) - Ez dot |: BETA NB. Ezz
NB. m-step
  W=: (|: Ez) dot %. Ezz NB. lambda new
  psi=: ((<0 1) |: covar) - (< 0 1) |:(W dot Ez)
  PSI=: (psi *"_ 1 (=@i.) # psi )
  r=: +/A * |:covar
  L=: (--: N *^. +: PI) -0.5*LA + 0.5*r
  if. (|L-oldL)<EPSILON do.
    break.
  end.
  oldL=: L
end.
A=: PSI + W dot |: W
Ex=: (|: A) dot W
y dot Ex
)

destroy=: codestroy