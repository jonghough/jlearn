# Optimzation Methods

## L-BFGS

### Example
 BFGS Example 1 
Define a function which takes 3 real value arguments, g.
g= x^3 + y^3 + z^3 - (x^2 + 20x + y^2 +20y + z^2 +20z)
J tacitc syntax:

```j
g=:+/@:(^&3) - +/@:(*: + 20&*)
```

We can define the gradient of g, call it gprime:

```j
gprime=:3&*@:*: - 20&+@:+:
```

Start at arbitrary point (6.937, 22.937, 8.937).
Iterate for a maximum of 1000 epochs.
Set tolerance to 0,0001.
Beta, the inverse hessian initial scale factor is 0.01.

```j
]minima=:minBFGS_BFGS_ (g f.`'');(gprime f.`'');(6.937 22.937 8.937);1000;0.00001;0.01
```

This should give
2.93675 2.93675 2.93675

Double check gradient at this point.
gprime 2.93675 2.93675 2.93675

Which gives 1.6875e_6 1.6875e_6 1.6875e_6
This is (close enough to) zero, i.e. a local minimum.
)

### Example
BFGS Example 2

Example 1 used a symmetric function. Example 2 will use a function that
applies different operations to each component
Define function k:
k = exp(x) -z^2 - 2(x^4 + y^4 + z^4)
IN J:

```j
k=: (^@:{. - *:@:{:) - +/@:+:@:^&4
```

Gradient:

```j
kprime=: (_8&*@:^&3 + ^)@:{. , _8&*@:^&3@:(1&{) , (_8&*@:^&3 + *:)@:{:
```

Start at arbitrary point (2 1 _2).
Iterate for a maximum of 1000 epochs.
Set tolerance to 0,0001.
Beta, the inverse hessian initial scale factor is 0.001.

```j
]minima=:minBFGS_BFGS_ (k f.`'');(kprime f.`'');(2 1 _2);1000;0.00001;0.001
```

This should give
`0.613444 0.0107468 4.23329e_5`

Double check gradient at this point.

```j
kprime 0.613444 0.0107468 4.23329e_5
```

Which gives `2.50043e_6 _9.9295e_6 1.79147e_9`

## Conjugate Gradient

### Example 
Find the minimum value of the multivariate function
f(x,y,z) =  (x^2) - 2x + 3 +  (y^2) - 2y + 3 + (z^2) - 2z + 3
In J:

```j
f=: +/@:(3&+@:(*: - 2&*))
```

Partial derivatives of f are:

```j
fp=: _2&+@:+:
```

Find a mimimum (actually the global minimum), running for max of 1000 iterations,
with initial guess (x,y,z) = (0.1,0.5,0.1):

```j
minCG_jLearnOpt_ (f f. `'');(fp f.`'');(0.1 0.5 0.1); 1000; 0.001;'fr'
```

This gives:
```j
0.999843 0.999913 0.999843
```

This is close to the actual value of the only minimum of f:
(x,y,z) = (1,1,1)