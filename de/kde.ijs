Note 'References'
[1] Pattern Recognition and Machine Learning, Cristopher M. Bishop (Chapter 2)

[2] A tutorial on Kernel Density Estimation and Recent Advances, Yen-Chi Chen [arXiv:1704.03924]
)


NB. ref: https://scipy.github.io/devdocs/reference/generated/scipy.stats.gaussian_kde.html 
coclass 'KDE'

calch=: 3 : 0


)
kernalGaussian=: 3 : 0
sqrt2pi=. %: +: o.1
means=. +/ % #
my =. means y
ymy=. y -"1 _ my
dot=. +/ .*
S=.my dot |: my

)

NB. Instantiates KDEstimator
NB. Parameters:
NB. 0: kernel - kernel to use gaussian etc
NB. 1: grid size - grid size values, should be equal to the number of
NB.    features in the input data.
NB. 2: input (training) data.
create=: 3 : 0

'kernel gsz data'=: y
)

gridify=: (~.@:] ,: (% +/)@:(#/.~))@:([ * <.@%~)

 
fit=: 3 : 0
makeGrid ''
NB. joined probabilities
probs=: >  (({:&.>@:{.) (<@*"0 0"0 _&:>) {:&.>@{:)  gridz
gridvals=: (({.&.>@:{.) (<@,"0 0"0 _&:>) {.&.>@{:)  gridz
)

NB. the real makeGrid
makeGrid=: 3 : 0
sd=: /:~ data

gridz=:gsz <@([ gridify (/:~@:]))"0 1 |: data
gs=: # gridz
gridz0=: <"0 L: 0 {.&.> gridz
gridz1=: <"0 L: 0 {:&.> gridz
shape=: ,$&>gridz0
res=: >0{gridz0
pres=:>0{gridz1
for_i. i.gs do.
if. i -: 0 do. continue.end.

g1=: (i){gridz0
res=:(,res) ,&.>/"0 0"0 _ (>g1)

gr1=: (i){gridz1
pres=:(,pres) *&.>/"0 0"0 _ (>gr1)

end.
probs=: shape $, pres
gridvals=:shape $ ,res
)

sample=: 3 : 0

)

destroy=: codestroy
