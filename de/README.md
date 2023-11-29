# Kernel Density Estimation

KDE estimates a probability density function for a given dataset, by using 
various kernel operators.

## Implementation

This is an implementation of the KDE algorithm, with possible kernels:

* 'gauss' - for gaussian kernel
* 'epanechnikov'
* 'uniform'
* 'triangle'


## Example

```j
NB. generate some random data.
NB. we will create some 1-D sample data.
data=:100%~ 250 1 $ /:~ ? >: 100 | i. 500
kde =: ('epanechnikov';0.1;data) conew 'KDE'
fit__kde ''

NB. we can see the probability for each slot.

probs__kde
0.236 0.112 0.132 0.104 0.092 0.068 0.072 0.064 0.08 0.04
```


## Example with 2-D data

```j
data=:100%~ 250 2 $ /:~ ? >: 100 | i. 500
NB. create KDE and fit data
kde=:  ('gauss';0.1;data) conew 'KDE'
fit__kde '' 

NB. generate some sample
sample=: <@(%&10)@(2&#)"0@i.
sampleVal__kde sample 10

NB. simple 3d plot
load 'plot'
'surface;viewsize 1 1 0.6;viewpoint 1.6 _2.4 1.5' plot sampleVal__kde <"1 ,/"0 0"0 _~ 30%~ i. 30
```