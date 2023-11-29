Note 'References'
[1] Pattern Recognition and Machine Learning, Cristopher M. Bishop (Chapter 2)

[2] A tutorial on Kernel Density Estimation and Recent Advances, Yen-Chi Chen [arXiv:1704.03924]

[3] Statistical Pattern Recognition, Andrew Webb, 2nd Ed. (Chapter 2)
)




NB. ref: https://scipy.github.io/devdocs/reference/generated/scipy.stats.gaussian_kde.html
coclass 'KDE'


K=: 1 : 0
(h*#x)%~ +/"1 h&u (+/&.:*:)"1 h%~x -"1 1"_ 1 y
)

kernalGaussian=: 3 : 0
sqrt2pi=. %: +: o.1
means=. +/ % #
my=. means y
ymy=. y -"1 _ my
dot=. +/ .*
S=. my dot |: my

)

NB. Instantiates KDEstimator
NB. Parameters:
NB. 0: kernel - kernel to use. Options are 'gauss', 'triangle', 'uniform', 'epanechnikov'.
NB. 1: grid size - grid size values, should be equal to the number of
NB.    features in the input data.
NB. 2: input (training) data.
NB.
NB. Example usage:
NB. > data=: 250 2 $ /:~ ? >: 100 | i. 500     NB. create sample data.
NB. > sample=: <@(%&10)@(2&#)"0@i.             NB. utility verb for creating test samples
NB. > kde=:  ('gauss';0.1;data) conew 'KDE'    NB. use gaussian kernel.
NB. > fit__kde ''                              NB. fit the sample data.
NB. > sampleVal__kde sample 10
create=: 3 : 0

'kernel gsz data'=: y

if. kernel -: 'gauss' do.
  kernelV=: gauss
elseif. kernel -: 'epanechnikov' do.
  kernelV=: epanechnikov
elseif. kernel -: 'triangle' do.
  kernelV=: triangle
elseif. kernel -: 'uniform' do.
  kernelV=: uniform
elseif. 1 do.
  smoutput 'Kernel argument unknown: ',(": kernel)
  throw.
end.
gsz=: optimizeBandwidth ''
0
)

NB. Gaussian kernel
gauss=: 3 : 0"0
r2pi=. %: +: o. 1
h=. gsz
((%&r2pi)@:^@:-@:*:@:(+/)&.:*:) y
)

NB. epanachnikov kernel
epanechnikov=: 3 : 0

a=. 0.75 * (+/)&.:*: (1 - *: y)
if. (|a) > 1 do.
  a=. 0
end.
a
)
NB. Uniform kernel
uniform=: 3 : 0
0.5*y
)

NB.triangle kernel
triangle=: 3 : 0
a=. 1 - (+/)&.:*: y
if. (|a) > 1 do.
  a=. 0
end.
a
)

gridify=: (~.@:] ,: (% +/)@:(#/.~))@:([ * <.@%~)

NB. Fit the mode with the sample data.
fit=: 3 : 0
makeGrid ''
)

NB. Select kernel based on the string literal argument, y.
selectKernel=: 3 : 0
if. y -: 'gauss' do.
  kernelV=: gauss
elseif. y -: 'epanechnikov' do.
  kernelV=: epanechnikov
elseif. 1 do.
  smoutput 'Kernel argument unknown: ',(": y)
  throw.
end.
''
)

NB. Makes a grid of probability values for the bandwidth size, and
NB. a grid of the actual coordinates of the grid buckets for eac value.
NB. The probability values and grid coordiante values are both returned
NB. as a boxed list ( probabilities ; grid values ).
NB. The dimension of both depends on the dimension of the data.
NB.
NB. The probability values can also be retrieved by
NB. > probs__kde NB. assumes you KDEEstimator object is named 'kde'
NB. The grid values can be retrieved by
NB. > gridvals__kde
NB. Arguments:
NB.	y: None
NB. Returns:
NB.	probabilties values and grid values
makeGrid=: 3 : 0
gridz=. gsz <@([ gridify (/:~@:]))"0 1 |: data
gs=. # gridz
gridz0=. <"0 L: 0 {.&.> gridz
gridz1=. <"0 L: 0 {:&.> gridz
shape=. ,$&>gridz0
res=. >0{gridz0
pres=. >0{gridz1
for_i. i.gs do.
  if. i -: 0 do. continue.end.
  
  g1=. (i){gridz0
  res=. (,res) ,&.>/"0 0"0 _ (>g1)
  
  gr1=. (i){gridz1
  pres=. (,pres) *&.>/"0 0"0 _ (>gr1)
  
end.
probs=: shape $, pres
gridvals=: shape $ ,res
probs;gridvals
)



NB. Optimize the bandwith using technique described in [3] p.111-112.
optimizeBandwidth=: 3 : 0
p=. ({: $ data)
n=. # data
dot=. +/ .*
columnmean=. +/ % #
cov=. (|:@:[ dot ])/~@:(-"1 1 columnmean) % <:@:#
trace=. +/@:((<0 1)&|:)
s=. %: p %~ trace cov data
s * ((4 % p+2) ^ (% p+4)) * n ^(-%p+4)
)

createKernelArgs=: 4 : 0"_ 0
gridvals ((%&x)@:-)&.>"0 0"0 1 y
)

NB. sample a value. Value should be a boxed noun, the contents of which should have the
NB. same shape as the datapoints in the input dataset.
NB. Example:
NB. sampleVal__kde < 2 2
sampleVal=: 3 : 0"0
h=. gsz
p=. ({: $ data)
r=. %(h^p)*# data
r*+/+/+/"1 ,"1 > probs *&.> kernelV&.> h createKernelArgs"_ 0 y
)
destroy=: codestroy
