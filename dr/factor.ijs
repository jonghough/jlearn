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
m=: columnmean y
Xp=: X-"1 1 m
covar=: covGM Xp

psi=: (<0 1) |: covar
PSI=: (psi *"_ 1 (=@i.) # psi )
sqrtPsi=: EPSILON + %: psi
N=: # A

it=. 0
oldL=: __
while. 100000 > it=. it+1 do.
  
  A=: PSI + W dot |: W
  LA=: ^. | (-/ .*) A
  A=: %. A
  
  WA=: A dot~ |: W NB. WA is BETA
  WAC=: WA dot covar NB. Ez
  EXX=: ((=@i.) reducedDims) - (WA dot W) - WAC dot |: WA NB. Ezz
  
 
  W=: (|: WAC) dot %. EXX NB. lambda new
  psi=: ((<0 1) |: covar) - (< 0 1) |:(W dot WAC)
  PSI=: (psi *"_ 1 (=@i.) # psi )
  tAC=: +/A * |:covar
  L=: (--: N *^. 6.28) -0.5*LA + 0.5*tAC
  if. (|L-oldL)<EPSILON do.
    break.
  end.
  oldL=: L
end.
A=: (psi *"_ 1 (=@i.) # psi ) + ( W) dot |: W
Ex=: (|: A) dot W
y dot Ex

NB. now(psi* (=@i.) #psi)+  W dot |: W should approx cv
NB. i.e. We have approximated covariance matrix by WWt +psi
)

destroy=: codestroy

 