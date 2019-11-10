# Gaussian Processes

## Gaussian Process Regression Example

```
NB. Create a 2d dataset. 21 points, (x,y).
A=: 21 2 $ _1 0 _0.9 0.12 _0.8 0.15 _0.7 0.23 _0.6 0.26 _0.5 0.29 _0.4 0.31 _0.3 0.35 _0.2 0.4 _0.1 0.46 0 0.52 0.1 0.6 0.2 0.65 0.3 0.72 0.4 0.74 0.5 0.85 0.6 0.875 0.7 0.9 0.8 0.925 0.9 0.95 1 1
sin=: 1&o.
NB. some function, sin(x^2 - 2.1*y)
f=: sin@:(*:@:{. - 2.1&*@:{:)
NB. 21 targets
t=: 21 1 $ f"1 A
NB. create a Gaussian Process Regressor. Use LBFGS algorithm to find
NB. best fit. Other option is 'cg', for Conjugate Gradient.
gp=: (A;t;1;'expSquared';'lbfgs';1e3;1e_3) conew 'GPBase'
NB. Search for best fit hyper-parameters, with the inital guess (-2,1,-100)
fit__gp _2 1 _100 NB. _2.05768 0.939797 _100
NB. test points. 14 points (x,y)
test=: 14 2 $ 0.5 0 0.5 0.15 0.5 0.225 0.5 0.42 0.5 0.45 0.5 0.54 0.5 0.58 0.5 0.63 0.5 0.7 0.5 0.725 0.5 0.795 0.5 0.85 0.5 0.887 0.5 0.95
(  14 1 $ <"0 f"1 test),. predict__gp"1 test
┌──────────┬─────────┬──────────┐
│0.247404  │_0.480207│0.0898489 │
├──────────┼─────────┼──────────┤
│_0.0649542│_0.616192│0.0714206 │
├──────────┼─────────┼──────────┤
│_0.220669 │_0.684323│0.0610734 │
├──────────┼─────────┼──────────┤
│_0.59076  │_0.845887│0.0334322 │
├──────────┼─────────┼──────────┤
│_0.640385 │_0.867204│0.0294299 │
├──────────┼─────────┼──────────┤
│_0.773281 │_0.923024│0.0184794 │
├──────────┼─────────┼──────────┤
│_0.823753 │_0.943385│0.0142845 │
├──────────┼─────────┼──────────┤
│_0.878637 │_0.964529│0.00977363│
├──────────┼─────────┼──────────┤
│_0.939099 │_0.98549 │0.00504774│
├──────────┼─────────┼──────────┤
│_0.955839 │_0.990412│0.00385784│
├──────────┼─────────┼──────────┤
│_0.988577 │_0.996761│0.00203667│
├──────────┼─────────┼──────────┤
│_0.999359 │_0.993972│0.00223296│
├──────────┼─────────┼──────────┤
│_0.999122 │_0.988257│0.00318357│
├──────────┼─────────┼──────────┤
│_0.984865 │_0.971585│0.00629025│
└──────────┴─────────┴──────────┘
NB. plot the graph
plot |: ((>@:{.) (+ ,[, -) (>@:{:) )"1 predict__gp"1 test
```

![gpr](/gp/gpr.png)

## Example 2

Same as above, but simpler function to estimate.
Define twenty points.
```j
X=: 20 1 $ 10%~ i: 10
```
And target values for each point. Use a very simpel function (cos (x)).

```j
Y=:2 o. 5 * X
```

```j
gp=: (X;Y;1;'expSquared';'lbfgs';1e2;1e_3) conew 'GPBase'
fit__gp _2 _1 _10
```
We can then test visually, with a plot on values. (load plot package first).

```j
plot , >{."1 predict__gp"0[ 500%~ i: 500
```
You should see the function estimate gives a nice sinusoidal wave, matching the
cosine function very well. Clearly, this example is very simple, but gives a good
verification that the method works in - at the very least - simple scenarios.

### Example using Linear Kernel
Using the previous example's data, we can use a linear kernel to predict the 
values, instead of the squared exponential kernel
```j
gp=: (A;t;0;'linear';'cg';1e3;1e_2) conew 'GPBase'
fit__gp 0 _0.55 0
plot |: ((>@:{.) (+ ,[, -) (>@:{:) )"1 predict__gp"1 test
```
