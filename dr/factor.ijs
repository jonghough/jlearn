Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)
NB. Factor Analysis.

Notes 'References'
[1] Scikit-Learn Factor Analysis implementation
link: https://github.com/scikit-learn/scikit-learn 
)

NB. Factor Analysis. Reduces the dataset dimensionality to a
NB. smaller matrix which has linearly independent features
coclass 'FASolver'

dot=. +/ .*
columnmean=: +/ % #
NB. covGM generates a covariance matrix for the
NB. given data set.
covGM=: 100 * ((|:@:[dot])/~@:(-"1 1 columnmean) % (<:@:#))


create=: 3 : 0
'X c'=:y
)

eStep=: 3 : 0
m=. columnmean X
Xp=. X-m
cv=. 

)

mStep=: 3 : 0

)

fit=: 3 : 0
assert. 1 <: y
c=.0
err=. 1e4
while. y > c=.c+1 do.
eStep ''
mStep ''
if. do. break. end.
end.

)


destroy=: codestroy